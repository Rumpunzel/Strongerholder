extends ActionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	blackboard.character.current_interaction = CharacterController.ObjectInteraction.new(null, CharacterController.ObjectInteraction.InteractionType.ATTACK)
	return Status.RUNNING
