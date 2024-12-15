extends ConditionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	if get_tree().is_input_handled():
		return Status.FAILURE
	
	return Status.SUCCESS
