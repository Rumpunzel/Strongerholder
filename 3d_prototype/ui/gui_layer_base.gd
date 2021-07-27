class_name GUILayerBase
extends Popup

signal showed(layer)

export var _animation_duration: float = 0.3

var _tween


func _enter_tree() -> void:
	_tween = $Tween
	
	# warning-ignore:return_value_discarded
	get_viewport().connect("size_changed", self, "_update_size")


func show_menu() -> void:
	if visible:
		return
	
	_show_menu()
	emit_signal("showed", self)

func hide_menu() -> void:
	if not visible:
		return
	
	_hide_menu()


func _show_menu() -> void:
	popup()
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate:a", 0.0, 1.0, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.start()

func _hide_menu() -> void:
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate:a", 1.0, 0.0, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_IN)
	# warning-ignore:return_value_discarded
	_tween.start()
	yield(_tween, "tween_all_completed")
	hide()


func _update_size() -> void:
	rect_size = get_viewport().size


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Structure
	warning = "Layer requires a Tween"
	for child in get_children():
		if child is Tween:
			warning = ""
			break
	
	return warning
