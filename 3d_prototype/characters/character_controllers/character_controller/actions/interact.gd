extends ActionLeaf

func on_update(blackboard: CharacterBlackboard) -> int:
	var animation_parameter: String = blackboard.current_interaction.to_animation_parameter()
	print(animation_parameter)
	blackboard.animation_tree.set(animation_parameter, true)
	return Status.RUNNING
