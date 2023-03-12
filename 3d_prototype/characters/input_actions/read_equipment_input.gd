extends ActionLeaf

export(Resource) var _equipment_hud_toggled_channel

func on_update(blackboard: CharacterController.CharacterBlackboard) -> int:
	if Input.is_action_just_released("open_equipment_menu"):
		# warning-ignore-all:unsafe_property_access
		_equipment_hud_toggled_channel.raise(blackboard.inventory)
		return Status.SUCCESS
	
	return Status.FAILURE
