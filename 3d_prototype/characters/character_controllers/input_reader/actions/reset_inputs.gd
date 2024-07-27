extends ActionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	blackboard.character.current_interaction = null
	return Status.SUCCESS
