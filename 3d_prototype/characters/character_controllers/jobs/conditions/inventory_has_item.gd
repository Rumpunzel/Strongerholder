extends ConditionLeaf

enum ActionType { GATHERS, DELIVERS }

export(ActionType) var _action_type


func on_update(blackboard: CharacterBlackboard) -> int:
	var inventory := blackboard.inventory
	var item_to_check := _determine_item_to_check(blackboard.job)
	if inventory.contains(item_to_check) != null:
		return Status.SUCCESS
	return Status.FAILURE

func _determine_item_to_check(job: Workstation.Job) -> ItemResource:
	match _action_type:
		ActionType.GATHERS:
			# warning-ignore:unsafe_property_access
			return job.gathers
		
		ActionType.DELIVERS:
			# warning-ignore:unsafe_property_access
			return job.delivers
	
	return null
