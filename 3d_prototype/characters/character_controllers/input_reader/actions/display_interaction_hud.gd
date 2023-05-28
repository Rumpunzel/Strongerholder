extends CharacterActionLeaf

export(Resource) var _player_interaction_channel

func on_update(blackboard: OccupationBlackboard) -> int:
	var highlighted_target: CharacterController.Target = blackboard.current_target
	if not highlighted_target:
		highlighted_target = blackboard.nearest_percieved_target(true)
	
	if not highlighted_target:
		_player_interaction_channel.raise(null)
		return Status.SUCCESS
	
	if highlighted_target.node is Stash and highlighted_target is CharacterController.ItemInteraction and highlighted_target.interaction_type == CharacterController.ItemInteraction.InteractionType.GIVE:
		_player_interaction_channel.raise(highlighted_target)
	return Status.SUCCESS