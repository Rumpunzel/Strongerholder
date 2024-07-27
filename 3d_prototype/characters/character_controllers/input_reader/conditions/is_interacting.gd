extends ConditionLeaf

export(CharacterController.ObjectInteraction.InteractionType) var _interaction_type

func on_update(blackboard: OccupationBlackboard) -> int:
	var current_target := blackboard.character.current_interaction
	if current_target is CharacterController.ObjectInteraction and current_target.interaction_type == _interaction_type:
		return Status.SUCCESS
	
	return Status.FAILURE
