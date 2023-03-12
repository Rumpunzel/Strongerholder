extends CharacterActionLeaf

func on_update(blackboard: CharacterController.CharacterBlackboard) -> int:
	if Input.is_action_pressed("smart_interact"):
		if not blackboard.nearest_interaction:
			blackboard.nearest_interaction = _nearest_percieved_target(blackboard, true)
		if blackboard.nearest_interaction:
			return Status.RUNNING
	
	return Status.FAILURE
