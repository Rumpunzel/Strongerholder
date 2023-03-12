extends ActionLeaf

func on_update(blackboard: CharacterController.CharacterBlackboard) -> int:
	if Input.is_action_pressed("attack"):
		blackboard.current_interaction = CharacterController.ObjectInteraction.new(null, CharacterController.ObjectInteraction.InteractionType.ATTACK)
		return Status.RUNNING
	
	return Status.FAILURE
