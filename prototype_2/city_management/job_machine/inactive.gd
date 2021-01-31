class_name JobStateInactive, "res://assets/icons/game_actors/states/icon_state.svg"
extends JobState




func _ready() -> void:
	name = INACTIVE




func activate(first_time: bool = false, tool_type = null) -> void:
	if first_time:
		exit(JUST_STARTED, [tool_type])
	else:
		exit(IDLE)

func deactivate() -> void:
	pass


func is_active() -> bool:
	return false
