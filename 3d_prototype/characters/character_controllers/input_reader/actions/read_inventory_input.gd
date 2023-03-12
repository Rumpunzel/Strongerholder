extends ActionLeaf

export(Resource) var _inventory_hud_toggled_channel

func on_update(blackboard: Occupation.OccupationBlackboard) -> int:
	if Input.is_action_just_released("open_inventory"):
		# warning-ignore-all:unsafe_property_access
		_inventory_hud_toggled_channel.raise(blackboard.inventory)
		return Status.SUCCESS
	
	return Status.FAILURE
