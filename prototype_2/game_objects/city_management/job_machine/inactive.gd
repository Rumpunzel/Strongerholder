class_name JobStateInactive, "res://assets/icons/game_actors/states/icon_state.svg"
extends JobState



func activate(first_time: bool = false):
	if first_time:
		exit(JUST_STARTED)
	else:
		exit(IDLE)

func deactivate():
	pass


func is_active() -> bool:
	return false
