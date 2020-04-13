class_name ActorStats
extends ObjectStats


export var move_speed: float = 4.0 setget , get_move_speed
export var sprint_modifier: float = 2.0 setget , get_sprint_modifier
export var jump_speed: float = 20.0 setget , get_jump_speed



func get_move_speed() -> float:
	return move_speed

func get_sprint_modifier() -> float:
	return sprint_modifier

func get_jump_speed() -> float:
	return jump_speed
