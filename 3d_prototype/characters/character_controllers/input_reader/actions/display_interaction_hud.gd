extends CharacterActionLeaf

export(Resource) var _player_interaction_channel

func on_update(blackboard: Occupation.OccupationBlackboard) -> int:
	var character_blackboard: CharacterController.CharacterBlackboard = blackboard.character_blackboard
	var nearest_interaction: CharacterController.Target = character_blackboard.nearest_interaction
	if not nearest_interaction:
		nearest_interaction = _nearest_percieved_target(character_blackboard, true)
	
	if not nearest_interaction:
		_player_interaction_channel.raise(null)
		return Status.SUCCESS
	
	if nearest_interaction.node is Stash and nearest_interaction is CharacterController.ItemInteraction and nearest_interaction.type == CharacterController.ItemInteraction.InteractionType.GIVE:
		_player_interaction_channel.raise(nearest_interaction)
	return Status.SUCCESS
