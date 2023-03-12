extends ActionLeaf

func on_update(_blackboard: CharacterController.CharacterBlackboard) -> int:
	get_tree().set_input_as_handled()
	return Status.SUCCESS
