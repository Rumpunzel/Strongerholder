extends ConditionLeaf

func on_update(blackboard: CharacterBlackboard) -> int:
	if blackboard.current_interaction:
		return Status.SUCCESS
	return Status.FAILURE
