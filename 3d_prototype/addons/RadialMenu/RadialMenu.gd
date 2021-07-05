tool
extends Popup
"""
(c) 2021 Pascal Schuppli

This code is made available under the MIT license. See the LICENSE file for 
further information.
"""


""" Signal is sent when an item is selected. Opening a submenu doesn't emit
	this signal; if you are interested in that, use the submenu's about_to_show
	signal. """
signal item_selected(id, position)
""" Signal is sent when you hover over an item """
signal item_hovered(item)
""" Signal is sent when the menu is closed without anything being selected """
signal cancelled()

const Draw = preload("drawing_library.gd")

const DEBUG = false
const DEFAULT_THEME = preload("dark_default_theme.tres")
const STAR_TEXTURE = preload("icons/Favorites.svg")
const BACK_TEXTURE = preload("icons/Back.svg")
const CLOSE_TEXTURE = preload("icons/Close.svg")

const JOY_DEADZONE = 0.2
const JOY_AXIS_RESCALE = 1.0/(1.0-JOY_DEADZONE)

const ITEM_ICONS_NAME = "ItemIcons"
const TWEEN_NAME = "Tween"

# defines how long you have to wait before releasing a mouse button will 
# close the menu.
const MOUSE_RELEASE_TIMEOUT = 400

enum Position { off, inside, outside }

export var radius := 150 setget _set_radius
export var width := 50 setget _set_width
export var center_radius := 20 setget _set_center_radius
export(Position) var selector_position = Position.inside setget _set_selector_position
export(Position) var decorator_ring_position = Position.inside setget _set_decorator_ring_position
export(float, 0.01, 1.0, 0.001) var circle_coverage = 0.66 setget _set_circle_coverage
export(float, -1.578, 4.712, 0.001) var center_angle = -PI/2 setget _set_center_angle
export var show_animation := true

export(float, 0.01, 1.0, 0.01) var animation_speed_factor = 0.2

export(float, 0, 10, 0.5) var outside_selection_factor = 3.0

export(float, 0.01, 2.0, 0.05) var icon_scale := 1.0 setget _set_icon_scale

# This stores the default colors and constants which will be overriden by a theme
export var default_theme : Theme = DEFAULT_THEME

var item_angle = PI/6 setget _set_item_angle

# default menu itemsmn
var menu_items = [
	{ 'texture': STAR_TEXTURE, 'title': 'Item1', 'id': 'arc_id1'},
	{ 'texture': STAR_TEXTURE, 'title': 'Item2', 'id': 'arc_id2'},	
	{ 'texture': STAR_TEXTURE, 'title': 'Item3', 'id': 'arc_id3'},	
	{ 'texture': STAR_TEXTURE, 'title': 'Item4', 'id': 'arc_id4'},	
	{ 'texture': STAR_TEXTURE, 'title': 'Item5', 'id': 'arc_id5'},	
	{ 'texture': STAR_TEXTURE, 'title': 'Item6', 'id': 'arc_id6'},	
	{ 'texture': STAR_TEXTURE, 'title': 'Item7', 'id': 'arc_id7'},	
] setget set_items

# mostly used for animation
enum MenuState { closed, opening, open, moving, closing}

# for gamepad input. Use setup_gamepad to change these values.
var gamepad_device = 0
var gamepad_axis_x = 0
var gamepad_axis_y = 1
var gamepad_deadzone = JOY_DEADZONE

var ready = false
var _item_children_present := false
var has_left_center = false				
var is_submenu = false					# true for submenus
var selected = -1						# currently selected menu item
var state = MenuState.closed			# state of the menu

var center_offset = null				# offset of the arc center from top left
var orig_item_angle = 0					# backup value for animation
var msecs_at_opened = 0					# msecs since start when menu openeed
var opened_at_position					# this is where user has clocked
var moved_to_position					# this is the actual center of the menu
var active_submenu_idx = -1

func _set_radius(new_radius):
	radius = new_radius
	_calc_new_geometry()	
	update()
	
func _set_width(new_width):
	width = new_width
	_calc_new_geometry()	
	update()

func _set_center_radius(new_radius):
	center_radius = new_radius	
	update()


func _set_selector_position(new_position):
	selector_position = new_position
	_calc_new_geometry()	
	update()
	
func _set_icon_scale(new_scale : float):
	icon_scale = new_scale
	_update_item_icons()	
	update()

func _set_item_angle(new_angle: float):
	item_angle = new_angle
	_calc_new_geometry()
	update()

func _set_circle_coverage(new_coverage: float):	
	item_angle = new_coverage * 2 * PI / menu_items.size()
	circle_coverage = new_coverage
	_calc_new_geometry()	
	update()

		
func _set_center_angle(new_angle: float):
	item_angle = circle_coverage * 2 * PI / menu_items.size()
	center_angle = new_angle
	_calc_new_geometry()
	update()
	
func _set_decorator_ring_position(new_pos):
	decorator_ring_position = new_pos
	_calc_new_geometry()	
	update()
	

func _calc_new_geometry():	
	var n = menu_items.size()
	var angle = circle_coverage * 2.0 * PI / menu_items.size()	
	var sa = center_angle - 0.5 * n * angle
	var aabb = Draw.calc_ring_segment_AABB(radius-get_total_ring_width(), radius, sa, sa + n*angle)		
	rect_min_size = aabb.size
	rect_size = rect_min_size
	rect_pivot_offset = -aabb.position
	center_offset = -aabb.position
	_update_item_icons()


func _create_subtree():
	"""
	Creates necessary child nodes of the radial menu
	"""
	if not get_node_or_null(ITEM_ICONS_NAME):
		var item_icons = Control.new()
		item_icons.name = ITEM_ICONS_NAME
		add_child(item_icons)
	if not get_node_or_null(TWEEN_NAME):
		var tween = Tween.new()
		tween.name = TWEEN_NAME
		add_child(tween)
		tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")

			
func _ready():		
	ready = true
	item_angle = circle_coverage * 2.0 * PI / menu_items.size()	
	_create_subtree()
	if not is_submenu:
		# (submenus get their signals connected and disconnected elsewhere)
		connect("about_to_show", self, "_about_to_show")
		connect("visibility_changed", self, "_on_visibility_changed")
	_register_menu_child_nodes()
	_calc_new_geometry()
	size_flags_horizontal = 0
	size_flags_vertical = 0
	

func _input(event):
	_radial_input(event)
	
func _radial_input(event):
	if not visible:
		return
	if state == MenuState.opening or state == MenuState.closing:
		get_tree().set_input_as_handled()
		return
			
	if event is InputEventMouseMotion:
		set_selected_item(get_selected_by_mouse())
	elif event is InputEventJoypadMotion:
		set_selected_item(get_selected_by_joypad())
		return
			
	if has_open_submenu():
		return
	
	if event is InputEventMouseButton:
		_handle_mouse_buttons(event)		
	else:
		_handle_actions(event)




func is_wheel_button(event):
	return event.button_index in [BUTTON_WHEEL_UP, BUTTON_WHEEL_DOWN, BUTTON_WHEEL_LEFT, BUTTON_WHEEL_RIGHT]

func _handle_mouse_buttons(event):
	if event.is_pressed():
		if event.button_index == BUTTON_WHEEL_DOWN:
			select_next()				
		elif event.button_index == BUTTON_WHEEL_UP:
			select_prev()
		else:
			if not is_submenu:					
				get_tree().set_input_as_handled()				
			activate_selected()											
	elif state == MenuState.open and not is_wheel_button(event):
		var msecs_since_opened = OS.get_ticks_msec() - msecs_at_opened			
		if msecs_since_opened > MOUSE_RELEASE_TIMEOUT:				
			get_tree().set_input_as_handled()
			activate_selected()
	

func _handle_actions(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		selected = -1
		activate_selected()		
	elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right") or event.is_action_pressed("ui_focus_next"):
		select_next()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_focus_prev"):
		select_prev()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		get_tree().set_input_as_handled()
		activate_selected()

	
func _draw():
	var count = menu_items.size()	
	if item_angle*count > 2*PI:
		item_angle = 2*PI/count
					
	var start_angle = center_angle - item_angle * (count/2.0)
	
	var inout = get_inner_outer()
	var inner = inout[0]
	var outer = inout[1]
	
	# Draw the background for each menu item
	for i in range(count):	
		var coords = Draw.calc_ring_segment(inner, outer, start_angle+i*item_angle, start_angle+(i+1)*item_angle, center_offset)
		if i == selected: 
			Draw.draw_ring_segment(self, coords, _get_color("Selected Background"), _get_color("Selected Stroke"), 0.5, true)
		else:
			Draw.draw_ring_segment(self, coords, _get_color("Background"), _get_color("Stroke"), 0.5, true)

	# draw decorator ring segment
	if decorator_ring_position == Position.outside:
		var rw = _get_constant("Decorator Ring Width")
		var coords = Draw.calc_ring_segment(outer, outer + rw, start_angle, start_angle+count*item_angle, center_offset)		
		Draw.draw_ring_segment(self, coords, _get_color("Ring Background"), null, 0, true)
	elif decorator_ring_position == Position.inside:
		var rw = _get_constant("Decorator Ring Width")
		var coords = Draw.calc_ring_segment(inner-rw, inner, start_angle, start_angle+count*item_angle, center_offset)
		Draw.draw_ring_segment(self, coords, _get_color("Ring Background"), null, 0, true)
		
	# draw selection ring segment
	if selected != -1 and not has_open_submenu():
		var selector_size = _get_constant("Selector Segment Width")		
		var select_coords
		if selector_position == Position.outside:
			select_coords = Draw.calc_ring_segment(outer, outer+selector_size, start_angle+selected*item_angle, start_angle+(selected+1)*item_angle, center_offset)			
			Draw.draw_ring_segment(self, select_coords, _get_color("Selector Segment"), null, 0, true)	
		elif selector_position == Position.inside:
			select_coords = Draw.calc_ring_segment(inner-selector_size, inner, start_angle+selected*item_angle, start_angle+(selected+1)*item_angle, center_offset)
			Draw.draw_ring_segment(self, select_coords, _get_color("Selector Segment"), null, 0, true)	

	if center_radius != 0:
		_draw_center()


func _draw_center():
	if is_submenu:
		return
	var bg = _get_color("Center Background")
	var fg = _get_color("Center Stroke")
	if selected == -1:		
		fg = _get_color("Selector Segment")
	var tex = CLOSE_TEXTURE
	if active_submenu_idx != -1:
		tex = BACK_TEXTURE
	draw_circle(center_offset, center_radius, bg)
	draw_arc(center_offset, center_radius, 0, 2*PI, center_radius, fg, 2, true)
	draw_texture(tex, center_offset-CLOSE_TEXTURE.get_size()/2, _get_color("Icon Modulation"))


func setup_gamepad(deviceid : int, xaxis : int, yaxis: int, deadzone : float = JOY_DEADZONE):
	gamepad_device = deviceid
	gamepad_axis_x = xaxis
	gamepad_axis_y = yaxis
	gamepad_deadzone = deadzone

func get_selected_by_mouse():
	"""
	Returns the index of the menu item that is currently selected by the mouse
	(or -1 when nothing is selected)
	"""
	
	if has_open_submenu():		
		if get_open_submenu().get_selected_by_mouse() != -1:
			# we don't change the selection while a submenu has a valid selection
			return active_submenu_idx
	
	var s = selected
	var mpos = get_local_mouse_position() - center_offset
	var lsq = mpos.length_squared()
	var inner_limit = min((radius-width)*(radius-width), 400)
	var outer_limit = (radius+width*outside_selection_factor)*(radius+width*outside_selection_factor)
	if is_submenu :
		inner_limit = pow(get_inner_outer()[0], 2)
	# make selection ring wider than the actual ring of items
	if lsq < inner_limit or lsq > outer_limit:
		# being outside the selection limit only cancels your selection if you've
		# moved the mouse outside since having made the selection...
		if has_left_center:
			s = -1
	else:
		has_left_center = true
		s = get_itemindex_from_vector(mpos)
	return s

func get_selected_by_joypad():
	if has_open_submenu():
		return active_submenu_idx
	
	var xAxis = Input.get_joy_axis(gamepad_device, gamepad_axis_x)
	var yAxis = Input.get_joy_axis(gamepad_device, gamepad_axis_y)
	if abs(xAxis) > gamepad_deadzone:
		if xAxis > 0:
			xAxis = (xAxis - gamepad_deadzone) * JOY_AXIS_RESCALE
		else:	
			xAxis = (xAxis + gamepad_deadzone) * JOY_AXIS_RESCALE
	else:
		xAxis = 0
	if abs(yAxis) > gamepad_deadzone:
		if yAxis > 0:
			yAxis = (yAxis - gamepad_deadzone) * JOY_AXIS_RESCALE
		else:
			yAxis = (yAxis + gamepad_deadzone) * JOY_AXIS_RESCALE
	else:
		yAxis = 0
	
	var jpos = Vector2(xAxis, yAxis)	
	var s = selected
	if jpos.length_squared() > 0.36:	
		has_left_center = true
		s = get_itemindex_from_vector(jpos)
		if s == -1:
			s = selected
	return s
	

func has_open_submenu():
	"""
	Determines whether the current menu has a submenu open
	"""
	return active_submenu_idx != -1

func get_open_submenu():
	"""
	Returns the submenu node if one is open, or null
	"""
	if active_submenu_idx != -1:
		return menu_items[active_submenu_idx].id
	else:
		return null

func select_next():
	"""
	Selects the next item in the menu (clockwise)
	"""
	var n = menu_items.size()
	if 2*PI - n*item_angle < 0.01 or selected < n-1:
		set_selected_item((selected+1) % n)
		has_left_center=false


func select_prev():
	"""
	Selects the previous item in the menu (clockwise)
	"""
	var n = menu_items.size()
	if 2*PI - n*item_angle < 0.01 or selected > 0:
		set_selected_item(int(fposmod(selected-1, n)))
		has_left_center=false	
	

func activate_selected():
	"""
	Opens a submenu or closes the menu and signals an id, depending on what
	was selected
	"""
	if selected != -1 and menu_items[selected].id is Popup:
		open_submenu(menu_items[selected].id, selected)	
	else:	
		close_menu()	
		signal_id()	

		
func _connect_submenu_signals(submenu):	
	submenu.connect("about_to_show", submenu, "_about_to_show")
	submenu.connect("visibility_changed", submenu, "_on_visibility_changed")	
	submenu.connect("item_selected", self, "_on_submenu_item_selected")
	submenu.connect("item_hovered", self, "_on_submenu_item_hovered")
	submenu.connect("cancelled", self, "_on_submenu_cancelled")

func _disconnect_submenu_signals(submenu):	
	submenu.disconnect("about_to_show", submenu, "_about_to_show")
	submenu.disconnect("visibility_changed", submenu, "_on_visibility_changed")	
	submenu.disconnect("item_selected", self, "_on_submenu_item_selected")
	submenu.disconnect("item_hovered", self, "_on_submenu_item_hovered")
	submenu.disconnect("cancelled", self, "_on_submenu_cancelled")


func _clear_item_icons():
	var p = $ItemIcons	
	if not p:
		return
	for node in p.get_children():
		p.remove_child(node)
		node.queue_free()
	_item_children_present = false


func _register_menu_child_nodes():	
	for item in get_children():
		if item.name == ITEM_ICONS_NAME:
			continue
		if item.name == TWEEN_NAME:
			continue
		# do something with the others
		

func _create_item_icons():
	if not ready:
		return	
	_clear_item_icons()
	var n = menu_items.size()
	if n == 0:
		return
	var start_angle = center_angle - item_angle * (n >> 1) 	
	var half_angle
	if n % 2 == 0:
		half_angle = item_angle/2.0
	else:
		half_angle = 0
		
	var r = get_icon_radius()
			
	var coords = Draw.calc_ring_segment_centers(r, n, 
		start_angle+half_angle, start_angle+half_angle+n*item_angle, center_offset)
	for i in range(n):
		var item = menu_items[i]
		if item != null:
			var sprite = Sprite.new()
			sprite.position = coords[i]
			sprite.centered = true
			sprite.texture = item.texture
			sprite.scale = Vector2(icon_scale, icon_scale)
			sprite.modulate = _get_color("Icon Modulation")
			$ItemIcons.add_child(sprite)
	_item_children_present = true


func _update_item_icons():
	if not _item_children_present:
		_create_item_icons()
		return
	var r = get_icon_radius()
	var n = menu_items.size()
	var start_angle = center_angle - item_angle * n * 0.5 + item_angle * 0.5
	
	# a heuristic - hide icons when they tend to outgrow their segment
	if item_angle < 0.01 or r*(item_angle/2*PI) < width * icon_scale:
		$ItemIcons.hide()		
	else:
		$ItemIcons.show()		
		
	var coords = Draw.calc_ring_segment_centers(r, n, 
		start_angle, start_angle+n*item_angle, center_offset)
	var i = 0
	var ni = 0
	var item_nodes = $ItemIcons.get_children()	
	while i < n:		
		var item = menu_items[i]		
		if item != null:			
			var sprite = item_nodes[ni]
			ni += 1
			sprite.position = coords[i]			
			sprite.scale = Vector2(icon_scale, icon_scale)
			sprite.modulate = _get_color("Icon Modulation")
		i=i+1


func get_inner_outer():
	"""
	Returns the inner and outer radius of the item ring (without selector
	and decorator)
	"""
	var inner
	var outer
	var drw = 0
	if decorator_ring_position == Position.outside:
		drw = _get_constant("Decorator Ring Width")
	
	if selector_position == Position.outside:
		var w = max(drw, _get_constant("Selector Segment Width"))
		inner = radius - w - width 
		outer = radius - w
	else:
		inner = radius - drw - width
		outer = radius - drw
	return Vector2(inner, outer)

		
func get_total_ring_width():
	"""
	Returns the total width of the ring (with decorator and selector)
	"""
	var dw = _get_constant("Decorator Ring Width")
	var sw = _get_constant("Selector Segment Width")
	if decorator_ring_position == selector_position:
		if decorator_ring_position == Position.off:
			return width
		else:
			return width+max(sw, dw) 
	elif decorator_ring_position == Position.off:
		return width+sw
	elif selector_position == Position.off:
		return width+dw
	else:
		return width+sw+dw


func get_icon_radius():
	"""
	Gets the radius at which the item icons are centered
	"""
	var so_width = 0
	var dr_width = 0
	if selector_position == Position.outside:
		so_width = _get_constant("Selector Segment Width")
	if decorator_ring_position == Position.outside:
		dr_width = _get_constant("Decorator Ring Width")
	return radius - width/2.0 - max(so_width, dr_width)

		
func _get_color(name):
	""" Gets theme color (or takes it from default theme) """
	if has_color(name, "RadialMenu"):
		return get_color(name, "RadialMenu")
	else:
		return default_theme.get_color(name, "RadialMenu")

func _get_constant(name):
	""" Gets theme constant (or takes it from default theme) """
	if has_constant(name, "RadialMenu"):
		return get_constant(name, "RadialMenu")
	else:
		return default_theme.get_constant(name, "RadialMenu")

func _clear_items():
	var n = $ItemIcons
	for node in n.get_children():
		n.remove_child(node)	
		node.queue_free()
	

func get_itemindex_from_vector(v: Vector2):
	"""
	Given a vector that originates in the center of the radial menu, 
	this will return the index of the menu item that lies along that
	vector.
	"""
	var n = menu_items.size()	
	var start_angle = center_angle - item_angle * n / 2.0
	var end_angle = start_angle + n * item_angle
	
	var angle = v.angle_to(Vector2(cos(start_angle), sin(start_angle)))
	if angle < 0:
		angle = -angle
	else:
		angle = 2*PI-angle	
	var section = end_angle - start_angle  # wrap around bug?	

	var idx = int(fmod(angle/section, n)*n)
	if idx >= n:
		return -1
	else:
		return idx
				
func set_selected_item(itemidx):
	if selected == itemidx:
		return
	
	selected = itemidx
	if selected != -1:
		emit_signal("item_hovered", menu_items[selected])
		
	update()

func open_menu(center_position: Vector2):
	"""
	Opens the menu at the given position.
	
	:param center_position: The coordinates of the menu center.
	"""
			
	rect_position.x = center_position.x - center_offset.x
	rect_position.y = center_position.y - center_offset.y	
	item_angle = circle_coverage*2*PI/menu_items.size()
	_calc_new_geometry()
	popup()
	moved_to_position = rect_position + center_offset
	

func close_menu():
	if state != MenuState.open:
		return	
	has_left_center = false
	if not show_animation:
		state = MenuState.closed
		hide()
		get_parent().remove_child(self)
		is_submenu = false
	else:
		state = MenuState.closing
		orig_item_angle = item_angle	
		$Tween.interpolate_property(self, "item_angle", item_angle, 0.01, animation_speed_factor, Tween.TRANS_SINE, Tween.EASE_IN)
		$Tween.start()				

func open_submenu(submenu, idx):	
	active_submenu_idx = idx
	update()
	
	var ring_width = submenu.get_total_ring_width()
	
	submenu.decorator_ring_position = decorator_ring_position
	submenu.center_angle = idx * item_angle - PI + center_angle + item_angle/2.0	
	submenu.radius = radius + ring_width
	submenu.is_submenu = true		
	submenu.rect_position = moved_to_position - submenu.center_offset
		
	get_parent().add_child(submenu)
	_connect_submenu_signals(submenu)
	
	# now make sure we have room to display the menu
	var move = calc_move_to_fit(submenu)
	if not move:
		submenu.open_menu(moved_to_position)
		return
	
	if show_animation:
		state = MenuState.moving
		$Tween.interpolate_property(self, "rect_position", rect_position, rect_position+move, animation_speed_factor, Tween.TRANS_SINE, Tween.EASE_IN)
		$Tween.start()		
	else: 
		moved_to_position += move
		rect_position = moved_to_position - center_offset
		update()
		submenu.open_menu(moved_to_position)


func calc_move_to_fit(submenu):
	var parent_size = get_parent_area_size()
	var parent_rect = Rect2(Vector2.ZERO, parent_size)
	var sub_rect = submenu.get_rect()
	if not parent_rect.encloses(sub_rect):
		var dx = 0
		var dy = 0
		if sub_rect.position.x + sub_rect.size.x > parent_size.x:
			dx = parent_size.x - sub_rect.position.x - sub_rect.size.x
		elif sub_rect.position.x < 0:
			dx = -sub_rect.position.x
		if sub_rect.position.y + sub_rect.size.y > parent_size.y:
			dy = parent_size.y - sub_rect.position.y - sub_rect.size.y
		elif sub_rect.position.y < 0:
			dy = -sub_rect.position.y
		return Vector2(dx, dy)
	else: 
		return null


func _on_Tween_tween_all_completed():	
	if state == MenuState.closing:
		state = MenuState.closed
		hide()
		item_angle = circle_coverage*2*PI/menu_items.size()
		_calc_new_geometry()
		update()
		if is_submenu:
			get_parent().remove_child(self)
			is_submenu = false
	elif state == MenuState.opening:
		state = MenuState.open
		item_angle = circle_coverage*2*PI/menu_items.size()
		_calc_new_geometry()
		update()	
	elif state == MenuState.moving:
		state = MenuState.open
		moved_to_position = rect_position + center_offset
		menu_items[active_submenu_idx].id.open_menu(moved_to_position)
	
func signal_id():
	"""
	Emits either an 'item_selected' or 'cancelled' signal
	"""
	if selected != -1 and menu_items[selected] != null:
		emit_signal("item_selected", menu_items[selected].id, opened_at_position)
	elif selected == -1:
		emit_signal("cancelled")


func set_items(items):
	"""
	Changes the menu items. Expects a list of 3-item dictionaries with the
	keys 'texture', 'title' and 'id'.
	
	The value for the id can be anything you wish. If it is a RadialMenu,
	it will be treated as a submenu.
	"""
	_clear_items()
	menu_items = items
	_create_item_icons()
	#create_expand_icons()
	if visible:
		update()


func add_icon_item(texture : Texture, title: String, id):
	"""
	Adds a menu item
	
	:param texture: The texture to use for the icon
	:param title: A short title/label for the item
	:param id: A unique id. If it is a RadialMenu object, 
				   it will be treated as a submenu.
	"""
	var entry = { 'texture': texture, 'title': title, 'id': id}
	menu_items.push_back(entry)
	_create_item_icons()
	if visible:
		update()
	
func set_item_text(idx: int, text: String):
	"""
	Sets the title text of a menu item.
	
	:param idx: The item index. The item must exist!
	:param text: The title text
	"""
	if idx < menu_items.size():
		menu_items[idx].title = text
		_update_item_icons()
	else:
		print_debug("Invalid index {} in set_item_text" % idx)


func set_item_id(idx: int, id):
	"""
	Sets the id of a menu item.
	
	:param idx: The item index. The item must exist!
	:param id: The id that will be emitted by item_selected.
	
	Note: If the id is a RadialMenu, it will be treated as a submenu.
	"""
	if idx < menu_items.size():
		menu_items[idx].id = id
		_update_item_icons()
	else:
		print_debug("Invalid index {} in set_item_id" % idx)


func set_item_icon(idx: int, texture: Texture):
	"""
	Sets the icon of a menu item.
	
	:param idx: The item index. The item must exist!
	:param texture: A texture that will serve as the icon
	"""
	if idx < menu_items.size():
		menu_items[idx].texture = texture
		_update_item_icons()
	else:
		print_debug("Invalid index {} in set_item_texture" % idx)


func _about_to_show():
	selected = -1
	msecs_at_opened = OS.get_ticks_msec()	
	opened_at_position = Vector2(margin_left + center_offset.x, margin_top + center_offset.y)	
	if show_animation:
		orig_item_angle = item_angle
		item_angle = 0.01
		_calc_new_geometry()
		update()


func _on_visibility_changed():
	if not visible:
		state = MenuState.closed
	elif show_animation and state == MenuState.closed:
		state = MenuState.opening
		$Tween.interpolate_property(self, "item_angle", 0.01, orig_item_angle, animation_speed_factor, Tween.TRANS_SINE, Tween.EASE_IN)
		$Tween.start()
	else:
		state = MenuState.open


func _on_submenu_item_selected(id, position):	
	var submenu = get_open_submenu()
	_disconnect_submenu_signals(submenu)	
	active_submenu_idx = -1
	close_menu()	
	emit_signal("item_selected", id, opened_at_position)


func _on_submenu_item_hovered(_item):
	set_selected_item(active_submenu_idx)

	
func _on_submenu_cancelled():
	var submenu = get_open_submenu()
	_disconnect_submenu_signals(submenu)		
	set_selected_item(get_selected_by_mouse())
	if selected == -1 or selected == active_submenu_idx:
		get_tree().set_input_as_handled()	
	active_submenu_idx = -1
	update()
	
