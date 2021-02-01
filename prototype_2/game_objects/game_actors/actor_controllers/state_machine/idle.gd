class_name ActorStateIdle, "res://class_icons/states/icon_state_idle.svg"
extends ActorState




func _ready() -> void:
	name = IDLE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	_change_animation(IDLE)


func move_to(direction: Vector2, _is_sprinting: bool) -> void:
	if direction == Vector2():
		return
	
	exit(RUN)
