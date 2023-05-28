extends ActionLeaf

func on_update(blackboard: CharacterBlackboard) -> int:
	blackboard.character.destination_input = blackboard.current_interaction.position()
	return Status.RUNNING
