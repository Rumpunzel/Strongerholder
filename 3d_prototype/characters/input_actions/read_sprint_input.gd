extends ActionLeaf

func on_update(blackboard: CharacterController.CharacterBlackboard) -> int:
	var character := blackboard.character
	if Input.is_action_just_pressed("sprint"):
		character.sprint_input = true
	elif Input.is_action_just_released("sprint"):
		character.sprint_input = false
	
	return Status.SUCCESS
