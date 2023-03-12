extends ConditionLeaf

func on_update(blackboard: CharacterBlackboard) -> int:
	if blackboard.current_interaction and blackboard.current_interaction.node in blackboard.interaction_area.objects_in_area:
		return Status.SUCCESS
	return Status.FAILURE
