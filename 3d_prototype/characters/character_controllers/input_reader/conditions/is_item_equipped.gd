extends ConditionLeaf

func on_update(blackboard: Occupation.OccupationBlackboard) -> int:
	if blackboard.character_blackboard.inventory.has_something_equipped():
		return Status.SUCCESS
	
	return Status.FAILURE
