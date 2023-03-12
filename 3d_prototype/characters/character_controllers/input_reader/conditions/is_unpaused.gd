extends ConditionLeaf

func on_update(_blackboard: Occupation.OccupationBlackboard) -> int:
	if get_tree().paused:
		return Status.FAILURE
	
	return Status.SUCCESS
