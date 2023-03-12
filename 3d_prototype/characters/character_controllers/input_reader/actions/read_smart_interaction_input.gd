extends CharacterActionLeaf

func on_update(blackboard: Occupation.OccupationBlackboard) -> int:
	var character_black_board := blackboard.character_blackboard
	if Input.is_action_pressed("smart_interact"):
		if not character_black_board.nearest_interaction:
			character_black_board.nearest_interaction = _nearest_percieved_target(character_black_board, true)
		if character_black_board.nearest_interaction:
			return Status.RUNNING
	
	return Status.FAILURE
