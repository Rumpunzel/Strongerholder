class_name RadialMenuItem
extends TextureRect

export var _scale_on_selection := Vector2(1.2, 1.2)
export var _animation_time := 0.1

# Array of RadialMenuItems
var submenu_items := [ ]
var disabled := false setget _set_disabled

var _tween: Tween


func _enter_tree() -> void:
	_tween = Tween.new()
	add_child(_tween)


func highlight(is_highlighted: bool) -> void:
	var highlighted := false
	if is_highlighted and rect_scale == Vector2(1.0, 1.0):
		_tween.interpolate_property(self, "rect_scale", Vector2(1.0, 1.0), _scale_on_selection, _animation_time)
		highlighted = true
	elif not is_highlighted and not rect_scale == Vector2(1.0, 1.0):
		_tween.interpolate_property(self, "rect_scale", _scale_on_selection, Vector2(1.0, 1.0), _animation_time)
		highlighted = true
	
	if highlighted:
		_tween.start()


func set_texture(new_texture: Texture) -> void:
	.set_texture(new_texture)
	rect_pivot_offset = rect_min_size / 2.0

func _set_disabled(is_disabled: bool) -> void:
	highlight(false)
	disabled = is_disabled


func is_modified() -> bool:
	return false
