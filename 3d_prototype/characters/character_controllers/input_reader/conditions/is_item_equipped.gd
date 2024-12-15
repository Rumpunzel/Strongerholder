extends ConditionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	if blackboard.character.has_something_equipped():
		return Status.SUCCESS
	
	return Status.FAILURE
