extends CharacterActionLeaf

func on_update(blackboard: CharacterBlackboard) -> int:
	blackboard.nearest_interaction = blackboard.behavior_tree.nearest_interactable_target()
	return Status.SUCCESS
