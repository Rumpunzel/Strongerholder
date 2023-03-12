extends ConditionLeaf

func on_update(blackboard: CharacterController.CharacterBlackboard) -> int:
	if blackboard.inventory.has_something_equipped():
		return Status.SUCCESS
	
	return Status.FAILURE
