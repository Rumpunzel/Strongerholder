extends ActionLeaf

export(Resource) var _building_hud_toggled_channel

func on_update(blackboard: OccupationBlackboard) -> int:
	if Input.is_action_just_released("open_build_menu"):
		# warning-ignore-all:unsafe_property_access
		_building_hud_toggled_channel.raise()
		return Status.SUCCESS
	
	return Status.FAILURE
