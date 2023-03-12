extends CharacterActionLeaf

export(Resource) var _player_interaction_channel

func on_update(blackboard: CharacterController.CharacterBlackboard) -> int:
	var nearest_interaction := blackboard.nearest_interaction
	if not nearest_interaction:
		nearest_interaction = _nearest_percieved_target(blackboard, true)
	
	if not nearest_interaction:
		_player_interaction_channel.raise(null)
		return Status.SUCCESS
	
	if nearest_interaction.node is Stash and nearest_interaction is CharacterController.ItemInteraction and nearest_interaction.type == CharacterController.InteractionType.GIVE:
		_player_interaction_channel.raise(nearest_interaction)
	return Status.SUCCESS
