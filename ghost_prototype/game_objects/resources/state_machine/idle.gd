class_name ResourceStateIdle, "res://class_icons/states/icon_state_idle.svg"
extends ResourceState




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = IDLE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	emit_signal("active_state_set", true)
