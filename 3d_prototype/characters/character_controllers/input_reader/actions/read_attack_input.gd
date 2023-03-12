extends ActionLeaf

func on_update(blackboard: OccupationBlackboard) -> int:
	if Input.is_action_pressed("attack"):
		print("attacking")
		blackboard.current_target = CharacterController.ObjectInteraction.new(null, CharacterController.ObjectInteraction.InteractionType.ATTACK)
		print("blackboard.current_interaction: %s" % blackboard.current_target)
		return Status.RUNNING
	
	return Status.FAILURE
