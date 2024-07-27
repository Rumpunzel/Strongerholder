extends ActionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	if not blackboard.current_target:
		blackboard.current_target = blackboard.behavior_tree.nearest_interactable_target(true)
	if blackboard.current_target:
		return Status.SUCCESS
	
	return Status.FAILURE
