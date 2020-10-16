class_name ActorStateIdle, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends ActorState



func enter(_parameters: Array = [ ]):
	_change_animation(IDLE)
