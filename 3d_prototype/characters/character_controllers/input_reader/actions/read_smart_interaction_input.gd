extends CharacterActionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	if Input.is_action_pressed("smart_interact"):
		if not blackboard.current_target:
			blackboard.current_target = blackboard.nearest_percieved_target(true)
		if blackboard.current_target:
			return Status.RUNNING
	
	return Status.FAILURE
