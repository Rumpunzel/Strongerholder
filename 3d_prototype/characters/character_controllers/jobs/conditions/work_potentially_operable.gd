extends ConditionLeaf

func on_update(blackboard: CharacterBlackboard) -> int:
	return blackboard.job.employer.could_be_operated(blackboard.inventory)
