extends ActionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	blackboard.current_target = null
	return Status.SUCCESS
