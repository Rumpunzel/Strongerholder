extends ActionLeaf

export(CharacterController.ObjectInteraction.InteractionType) var _interaction_type

func on_update(blackboard: OccupationBlackboard) -> int:
	print("hello")
	var current_target := blackboard.character.current_interaction
	blackboard.character
	return Status.RUNNING
