class_name RadialMenuItem
extends TextureRect

export var _scale_on_selection := Vector2(1.2, 1.2)
export var _animation_time := 0.1

# Array of RadialMenuItems
var active_submenu_items := [ ]
# warning-ignore:unused_class_variable
var possible_submenu_items := { }
var disabled := false setget _set_disabled

var _tween: Tween


func _enter_tree() -> void:
	if not _tween:
		_tween = Tween.new()
		add_child(_tween)

func _exit_tree() -> void:
	for item in possible_submenu_items.values():
		item.queue_free()
	
	for item in active_submenu_items:
		item.queue_free()


func highlight(is_highlighted: bool) -> void:
	var highlighted := false
	
	if not is_inside_tree():
		return
	
	if is_highlighted and rect_scale == Vector2(1.0, 1.0):
		# warning-ignore:return_value_discarded
		_tween.interpolate_property(self, "rect_scale", Vector2(1.0, 1.0), _scale_on_selection, _animation_time)
		highlighted = true
	elif not is_highlighted and rect_scale != Vector2(1.0, 1.0):
		# warning-ignore:return_value_discarded
		_tween.interpolate_property(self, "rect_scale", _scale_on_selection, Vector2(1.0, 1.0), _animation_time)
		highlighted = true
	
	if highlighted:
		# warning-ignore:return_value_discarded
		_tween.start()


func set_texture(new_texture: Texture) -> void:
	.set_texture(new_texture)
	rect_pivot_offset = rect_min_size / 2.0

func set_submenu_items(new_items: Array) -> void:
	active_submenu_items.clear()
	
	for i in new_items.size():
		var new_item: int = new_items[i]
		var new_submenu_item: RadialMenuItem = possible_submenu_items.get(new_item, null)
		
		if new_submenu_item:
			active_submenu_items.append(new_submenu_item)

func _set_disabled(is_disabled: bool) -> void:
	highlight(false)
	disabled = is_disabled


func is_modified() -> bool:
	return false
