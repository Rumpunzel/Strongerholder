extends ConditionLeaf

func on_update(blackboard: Occupation.OccupationBlackboard) -> int:
	if get_tree().is_input_handled():
		return Status.FAILURE
	
	return Status.SUCCESS
