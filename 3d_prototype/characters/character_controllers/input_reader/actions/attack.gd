extends ActionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	blackboard.current_target = CharacterController.ObjectInteraction.new(null, CharacterController.ObjectInteraction.InteractionType.ATTACK)
	return Status.RUNNING
