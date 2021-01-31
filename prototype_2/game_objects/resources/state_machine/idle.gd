class_name ResourceStateIdle, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends ResourceState




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = IDLE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	_toggle_active_state(game_object, true)
