class_name GUILayerBase
extends Control

signal showed(layer)

export var _animation_duration: float = 0.3

onready var _tween: Tween = $Tween


func _ready() -> void:
	visible = false


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
	visible = true
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
	visible = false


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Structure
	warning = "Layer requires a Tween"
	for child in get_children():
		if child is Tween:
			warning = ""
			break
	
	return warning
