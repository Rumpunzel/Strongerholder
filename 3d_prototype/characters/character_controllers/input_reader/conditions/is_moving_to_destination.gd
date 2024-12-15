extends ConditionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	if Input.is_action_pressed("mouse_movement"):
		return Status.SUCCESS
	
	return Status.FAILURE
