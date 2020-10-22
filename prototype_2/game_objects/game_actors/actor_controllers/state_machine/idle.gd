class_name ActorStateIdle, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends ActorState



func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	_change_animation(IDLE)


func move_to(direction: Vector2, _is_sprinting: bool):
	if direction == Vector2():
		return
	
	exit(RUN)
