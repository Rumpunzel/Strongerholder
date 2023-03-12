extends ConditionLeaf

func on_update(blackboard: CharacterBlackboard) -> int:
	return blackboard.job.employer.employer.contains(blackboard.job.delivers) != null
