extends ActionLeaf

func on_update(_blackboard: Occupation.OccupationBlackboard) -> int:
	get_tree().set_input_as_handled()
	return Status.SUCCESS
