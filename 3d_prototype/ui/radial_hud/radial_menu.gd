class_name RadialMenu2
extends Popup
tool

signal item_selected(selected_item, submenu)
""" Signal is sent when you hover over an item """
signal item_hovered(item)
""" Signal is sent when the menu is closed without anything being selected """
signal cancelled()


enum Position { OFF, INSIDE, OUTSIDE }
enum MenuState { CLOSED, OPENING, OPEN, MOVING, CLOSING }


const _JOY_DEADZONE := 0.2
const _JOY_AXIS_RESCALE := 1.0 / (1.0 - _JOY_DEADZONE)


export var is_submenu := false
export(NodePath) var submenu_node

export var ring_radius := 250.0 setget _set_ring_radius
export var ring_width := 100.0 setget _set_ring_width

export(float, 0.01, 1.0) var circle_coverage := 1.0 setget _set_circle_coverage
export(float, -360.0, 360.0) var center_angle2 := 0.0 setget _set_center_angle

export var icon_size := Vector2(64.0, 64.0)

export var show_animation := true
export(float, 0.01, 1.0, 0.01) var animation_speed_factor := 0.2

export(Position) var selector_position := Position.OFF setget _set_selector_position
export(Position) var decorator_ring_position := Position.INSIDE setget _set_decorator_ring_position
export(float, 0, 10, 0.5) var outside_selection_factor := 3.0

# defines how long you have to wait before releasing a mouse button will close the menu.
export var mouse_release_timeout := 400.0


var menu_items := [ ] setget _set_items
var selected_item: RadialMenuItem = null setget _set_selected_item
var active_sub_menu: RadialMenuItem = null
var center_offset := Vector2.ZERO


# for gamepad input. Use setup_gamepad to change these values.
var _gamepad_device := 0
var _gamepad_axis_x := 0
var _gamepad_axis_y := 1
var _gamepad_deadzone := _JOY_DEADZONE

var _state: int = MenuState.CLOSED
var _item_angle := PI / 6.0 setget _set_item_angle
var _original_item_angle := 0.0
var _original_submenu_circle_coverage: float
var _msecs_at_opened := 0.0
var _moved_to_position: Vector2
var _has_left_center := false

var _ring: RadialMenuRing
var _item_icons: RadialMenuItemIcons
var _tween: Tween
var _submenu: RadialMenu2



func _enter_tree() -> void:
	_ring = RadialMenuRing.new()
	add_child(_ring)
	
	_item_icons = RadialMenuItemIcons.new()
	add_child(_item_icons)
	
	_tween = Tween.new()
	add_child(_tween)
	_tween.connect("tween_all_completed", self, "_on_tween_all_completed")
	
	_submenu = get_node_or_null(submenu_node)
	if _submenu:
		_original_submenu_circle_coverage = _submenu.circle_coverage
		_connect_submenu_signals(_submenu)
	
	if not is_submenu:
		# (submenus get their signals connected and disconnected elsewhere)
		connect("about_to_show", self, "_about_to_show")
		connect("visibility_changed", self, "_on_visibility_changed")


func _input(event: InputEvent) -> void:
	if _state == MenuState.OPEN:
		_radial_input(event)


func _draw() -> void:
	var count := menu_items.size()
	if count <= 0:
		return
	
	if _item_angle * count > TAU:
		_item_angle = TAU / float(count)
	
	var start_angle := deg2rad(center_angle2) - _item_angle * (count / 2.0)
	var inout := get_inner_outer()
	var inner := inout[0]
	var outer := inout[1]
	
	_ring.draw_item_backgrounds(self, menu_items, selected_item, _item_angle, center_offset, inner, outer, start_angle, count)
	_ring.draw_decorator_ring(self, decorator_ring_position, _item_angle, center_offset, inner, outer, start_angle, count)
	_ring.draw_selections_ring_segment(self, menu_items, selected_item, active_sub_menu, selector_position, _item_angle, center_offset, inner, outer, start_angle)
	
	_item_icons.update_item_icon(menu_items, selected_item, count)



func open_menu(center_position: Vector2) -> void:
	assert(not menu_items.empty())
	rect_position = center_position - center_offset
	_item_angle = circle_coverage * TAU / menu_items.size()
	_calc_new_geometry()
	popup()
	_moved_to_position = rect_position + center_offset


func open_submenu_on(menu_item: RadialMenuItem) -> void:#
	assert(menu_item)
	print(menu_item)
	active_sub_menu = menu_item
	update()
	
	var width := _submenu.get_total_ring_width()
	var item_id := menu_items.find(menu_item)
	
	assert(_submenu.is_submenu)
	_submenu.center_angle2 = rad2deg(item_id * _item_angle - PI + deg2rad(center_angle2) + _item_angle / 2.0)
	_submenu.ring_radius = ring_radius + width
	_submenu.rect_position = _moved_to_position - _submenu.center_offset
	_submenu.circle_coverage = (1.0 / float(menu_item.submenu_items.size())) * circle_coverage * _original_submenu_circle_coverage
	_submenu.menu_items = menu_item.submenu_items
	
	# now make sure we have room to display the menu
	var move := _calc_move_to_fit(_submenu)
	if not move:
		_submenu.open_menu(_moved_to_position)
		return
	
	if show_animation:
		_state = MenuState.MOVING
		_tween.interpolate_property(self, "rect_position", rect_position, rect_position + move, animation_speed_factor, Tween.TRANS_SINE, Tween.EASE_IN)
		_tween.start()
	else: 
		_moved_to_position += move
		rect_position = _moved_to_position - center_offset
		update()
		_submenu.open_menu(_moved_to_position)


func close_menu() -> void:
	if active_sub_menu:
		close_submenu()
	
	if _state != MenuState.OPEN:
		return
	
	_has_left_center = false
	if not show_animation:
		_state = MenuState.CLOSED
		hide()
	else:
		_state = MenuState.CLOSING
		_original_item_angle = _item_angle
		_tween.interpolate_property(self, "_item_angle", _item_angle, 0.01, animation_speed_factor, Tween.TRANS_SINE, Tween.EASE_IN)
		_tween.start()


func close_submenu() -> void:
	_submenu.close_menu()
	active_sub_menu = null


func get_selected_by_mouse() -> RadialMenuItem:
	if active_sub_menu and _submenu.get_selected_by_mouse():
		return active_sub_menu
	
	var selected: RadialMenuItem = null
	var mouse_position := get_local_mouse_position() - center_offset
	var distance_squared := mouse_position.length_squared()
	var inner_limit := min((ring_radius - ring_width) * (ring_radius - ring_width), 400.0)
	var outer_limit := (ring_radius + ring_width * outside_selection_factor) * (ring_radius + ring_width * outside_selection_factor)
	
	if is_submenu:
		inner_limit = pow(get_inner_outer()[0], 2)
	#print("get_selected_by_mouse 1: %s" % selected)
	# make selection ring wider than the actual ring of items
	if distance_squared < inner_limit or distance_squared > outer_limit:
		# being outside the selection limit only cancels your selection if you've
		# moved the mouse outside since having made the selection...
		if _has_left_center:
			selected = null
	else:
		#print("get_selected_by_mouse 2: %s" % selected)
		#print("here")
		_has_left_center = true
		selected = _get_item_from_vector(mouse_position)
	#assert(selected)
	return selected if selected else selected_item


func get_selected_by_joypad() -> RadialMenuItem:
	if active_sub_menu:
		return selected_item
	
	var x_axis := Input.get_joy_axis(_gamepad_device, _gamepad_axis_x)
	var y_axis := Input.get_joy_axis(_gamepad_device, _gamepad_axis_y)
	
	if abs(x_axis) > _gamepad_deadzone:
		if x_axis > 0.0:
			x_axis = (x_axis - _gamepad_deadzone) * _JOY_AXIS_RESCALE
		else:
			x_axis = (x_axis + _gamepad_deadzone) * _JOY_AXIS_RESCALE
	else:
		x_axis = 0.0
	
	if abs(y_axis) > _gamepad_deadzone:
		if y_axis > 0:
			y_axis = (y_axis - _gamepad_deadzone) * _JOY_AXIS_RESCALE
		else:
			y_axis = (y_axis + _gamepad_deadzone) * _JOY_AXIS_RESCALE
	else:
		y_axis = 0.0
	
	var joystick_position := Vector2(x_axis, y_axis)
	var selected: RadialMenuItem = null
	
	if joystick_position.length_squared() > 0.36:
		_has_left_center = true
		selected = _get_item_from_vector(joystick_position)
	
	return selected if selected else selected_item


func get_total_ring_width() -> float:
	"""
	Returns the total width of the ring (with decorator and selector)
	"""
	var decorator_ring_width: float = _get_constant("decorator_ring_width")
	var selector_segment_width: float = _get_constant("selector_segment_width")
	
	if decorator_ring_position == selector_position:
		if decorator_ring_position == Position.OFF:
			return ring_width
		else:
			return ring_width + max(selector_segment_width, decorator_ring_width) 
	elif decorator_ring_position == Position.OFF:
		return ring_width + selector_segment_width
	elif selector_position == Position.OFF:
		return ring_width + decorator_ring_width
	else:
		return ring_width + selector_segment_width + decorator_ring_width


func get_inner_outer() -> Vector2:
	"""
	Returns the inner and outer radius of the item ring (without selector
	and decorator)
	"""
	var inner: float
	var outer: float
	var decorator_ring_width := 0.0
	
	if decorator_ring_position == Position.OUTSIDE:
		decorator_ring_width = _get_constant("decorator_ring_width")
	
	if selector_position == Position.OUTSIDE:
		var width := max(decorator_ring_width, _get_constant("selector_segment_width"))
		inner = ring_radius - width - ring_width 
		outer = ring_radius - width
	else:
		inner = ring_radius - decorator_ring_width - ring_width
		outer = ring_radius - decorator_ring_width
	
	return Vector2(inner, outer)



func _radial_input(event: InputEvent) -> void:
	if _state == MenuState.OPENING or _state == MenuState.CLOSING:
		get_tree().set_input_as_handled()
		return
	
	if event is InputEventMouseMotion:
		_set_selected_item(get_selected_by_mouse())
	elif event is InputEventJoypadMotion:
		_set_selected_item(get_selected_by_joypad())
		return
	
	if active_sub_menu:
		return
	
	if event is InputEventMouseButton:
		_handle_mouse_buttons(event)
	else:
		_handle_actions(event)


func _calc_new_geometry() -> void:
	assert(_item_icons)
	
	var item_count := menu_items.size()
	var angle_per_item := (TAU * circle_coverage) / float(item_count) if not menu_items.empty() else 0.01
	var start_angle := deg2rad(center_angle2) - 0.5 * item_count * angle_per_item
	var axis_aligned_bounding_box := DrawLibrary.calc_ring_segment_AABB(ring_radius - get_total_ring_width(), ring_radius, start_angle, start_angle + item_count * angle_per_item)
	
	rect_min_size = axis_aligned_bounding_box.size
	rect_size = rect_min_size
	rect_pivot_offset = -axis_aligned_bounding_box.position
	#center_offset = axis_aligned_bounding_box.position
	_item_icons.update_item_nodes(menu_items, deg2rad(center_angle2), _item_angle, _get_icon_radius(), center_offset, icon_size)


func _calc_move_to_fit(submenu: RadialMenu2) -> Vector2:
	var parent_size := get_parent_area_size()
	var parent_rect := Rect2(Vector2.ZERO, parent_size)
	var sub_rect := submenu.get_rect()
	
	if not parent_rect.encloses(sub_rect):
		var dx := 0.0
		var dy := 0.0
		
		if sub_rect.position.x + sub_rect.size.x > parent_size.x:
			dx = parent_size.x - sub_rect.position.x - sub_rect.size.x
		elif sub_rect.position.x < 0.0:
			dx = -sub_rect.position.x
		
		if sub_rect.position.y + sub_rect.size.y > parent_size.y:
			dy = parent_size.y - sub_rect.position.y - sub_rect.size.y
		elif sub_rect.position.y < 0.0:
			dy = -sub_rect.position.y
		
		return Vector2(dx, dy)
	else: 
		return Vector2.ZERO


func _handle_mouse_buttons(event: InputEventMouseButton) -> void:
	if event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			_select_next()
		elif event.button_index == BUTTON_WHEEL_UP:
			_select_prev()
		else:
			if not is_submenu:
				get_tree().set_input_as_handled()
			
			_activate_selected()
	elif _state == MenuState.OPEN and not _is_wheel_button(event):
		var msecs_since_opened := OS.get_ticks_msec() - _msecs_at_opened
		if msecs_since_opened > mouse_release_timeout:
			get_tree().set_input_as_handled()
			_activate_selected()


func _handle_actions(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		selected_item = null
		_activate_selected()
	elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_focus_next"):
		_select_next()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_focus_prev"):
		_select_prev()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		get_tree().set_input_as_handled()
		_activate_selected()


func _select_next() -> void:
	var item_count := menu_items.size()
	if selected_item or TAU - item_count * _item_angle <= 0.0:
		var next_selected: RadialMenuItem = menu_items[(menu_items.find(selected_item) + 1) % item_count]
		_set_selected_item(next_selected)
		_has_left_center = false


func _select_prev() -> void:
	var item_count := menu_items.size()
	if selected_item or TAU - item_count * _item_angle <= 0.0:
		var next_selected: RadialMenuItem = menu_items[(menu_items.find(selected_item) - 1 + item_count) % item_count]
		_set_selected_item(next_selected)
		_has_left_center = false


func _activate_selected() -> void:
	#	if active_sub_menu and not(_submenu.menu_items.has(selected_item) or selected_item == active_sub_menu):
#		close_submenu()
	print("_activate_selected: %s" % selected_item)
	print("_activate_selected: %s" % active_sub_menu)
	#assert(not selected_item == null)
	if selected_item and not selected_item.disabled and not selected_item.submenu_items.empty():
		pass#open_submenu_on(selected_item)
	else:
		_signal_id()


func _signal_id() -> void:
	if selected_item and not selected_item.disabled:
		emit_signal("item_selected", selected_item, null)
	else:
		emit_signal("cancelled")


func _connect_submenu_signals(submenu: RadialMenu2):
	submenu.connect("about_to_show", submenu, "_about_to_show")
	submenu.connect("visibility_changed", submenu, "_on_visibility_changed")
	submenu.connect("item_hovered", self, "_on_submenu_item_hovered")
	submenu.connect("item_selected", self, "_on_submenu_item_selected")
	submenu.connect("cancelled", self, "_on_submenu_cancelled")



func _on_submenu_item_hovered(item: RadialMenuItem) -> void:
	_set_selected_item(item)

func _on_submenu_item_selected(item: RadialMenuItem, submenu: RadialMenu2) -> void:
	emit_signal("item_selected", item, submenu)

func _on_submenu_cancelled() -> void:
	_set_selected_item(get_selected_by_mouse())

	if selected_item == null or menu_items.has(selected_item):
		get_tree().set_input_as_handled()

	close_submenu()
	update()


func _on_visibility_changed() -> void:
	if not visible:
		_state = MenuState.CLOSED
	elif show_animation and _state == MenuState.CLOSED:
		_state = MenuState.OPENING
		_tween.interpolate_property(self, "_item_angle", 0.01, _original_item_angle, animation_speed_factor, Tween.TRANS_SINE, Tween.EASE_IN)
		_tween.start()
	else:
		_state = MenuState.OPEN


func _about_to_show() -> void:
	_msecs_at_opened = OS.get_ticks_msec()
	
	if show_animation:
		_original_item_angle = _item_angle
		_item_angle = 0.01
		_calc_new_geometry()
		update()


func _on_tween_all_completed() -> void:
	if _state == MenuState.CLOSING:
		_state = MenuState.CLOSED
		hide()
		_item_angle = (circle_coverage * TAU / float(menu_items.size())) if not menu_items.empty() else 0.01
		_calc_new_geometry()
		update()
	elif _state == MenuState.OPENING:
		_state = MenuState.OPEN
		_item_angle = (circle_coverage * TAU / float(menu_items.size())) if not menu_items.empty() else 0.01
		_calc_new_geometry()
		update()
	elif _state == MenuState.MOVING:
		_state = MenuState.OPEN
		_moved_to_position = rect_position + center_offset
		_submenu.open_menu(_moved_to_position)



func _set_ring_radius(new_radius: float) -> void:
	ring_radius = new_radius
	_calc_new_geometry()
	update()

func _set_ring_width(new_width: float) -> void:
	ring_width = new_width
	_calc_new_geometry()
	update()

func _set_circle_coverage(new_coverage: float) -> void:
	_item_angle = (new_coverage * TAU / float(menu_items.size())) if not menu_items.empty() else 0.01
	circle_coverage = new_coverage
	if is_inside_tree():
		_calc_new_geometry()
		update()

func _set_center_angle(new_angle: float) -> void:
	_item_angle = (circle_coverage * TAU / float(menu_items.size())) if not menu_items.empty() else 0.01
	center_angle2 = new_angle
	_calc_new_geometry()
	update()

func _set_selector_position(new_position: int) -> void:
	selector_position = new_position
	_calc_new_geometry()
	update()

func _set_decorator_ring_position(new_position: int) -> void:
	decorator_ring_position = new_position
	_calc_new_geometry()
	update()

func _set_items(items: Array) -> void:
	_item_icons.clear_items()
	menu_items = items
	_item_icons.create_item_icons(menu_items, deg2rad(center_angle2), _item_angle, _get_icon_radius(), center_offset, icon_size)
	
	if visible:
		update()

func _set_selected_item(new_item: RadialMenuItem) -> void:
	if selected_item == new_item:
		return
	
	selected_item = new_item
	#assert(not selected_item == null)
	if selected_item:
		emit_signal("item_hovered", selected_item)
	
	update()

func _set_item_angle(new_angle: float) -> void:
	_item_angle = new_angle
	_calc_new_geometry()
	update()

func _set_constant(constant_name: String) -> void:
	set("constants/%s" % constant_name, _get_constant(constant_name))


func _get_constant(constant_name: String):
	return get_constant(constant_name, "RadialMenu2")

func _get_icon_radius() -> float:
	"""
	Gets the radius at which the item icons are centered
	"""
	var selector_segment_width := 0.0
	var decorator_ring_width := 0.0
	
	if decorator_ring_position == Position.OUTSIDE:
		decorator_ring_width = _get_constant("decorator_ring_width")
	
	if selector_position == Position.OUTSIDE:
		selector_segment_width = _get_constant("selector_segment_width")
	
	return ring_radius - ring_width / 2.0 - max(selector_segment_width, decorator_ring_width)

func _get_item_from_vector(vector: Vector2) -> RadialMenuItem:
	"""
	Given a vector that originates in the center of the radial menu, 
	this will return the index of the menu item that lies along that
	vector.
	"""
	var item_count := menu_items.size()
	var start_angle := deg2rad(center_angle2) - _item_angle * item_count / 2.0
	var end_angle := start_angle + item_count * _item_angle
	
	var angle := vector.angle_to(Vector2(sin(start_angle), cos(start_angle)))
	if angle < 0:
		angle += TAU
	
	var section := end_angle - start_angle
	var idx := int(angle / section * item_count) % item_count
	
	return menu_items[idx]

func _is_wheel_button(event: InputEventMouseButton) -> bool:
	return event.button_index in [ BUTTON_WHEEL_UP, BUTTON_WHEEL_DOWN, BUTTON_WHEEL_LEFT, BUTTON_WHEEL_RIGHT ]
