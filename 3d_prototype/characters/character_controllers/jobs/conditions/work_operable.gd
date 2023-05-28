extends ConditionLeaf

func on_update(blackboard: CharacterBlackboard) -> int:
	return blackboard.job.employer.can_be_operated()
