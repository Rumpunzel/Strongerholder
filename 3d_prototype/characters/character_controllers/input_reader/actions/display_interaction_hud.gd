extends CharacterActionLeaf

export(Resource) var _player_interaction_channel

func on_update(blackboard: OccupationBlackboard) -> int:
	var current_target: CharacterController.Target = blackboard.current_target
	if not current_target:
		current_target = blackboard.nearest_percieved_target(true)
	
	if not current_target:
		_player_interaction_channel.raise(null)
		return Status.SUCCESS
	
	if current_target.node is Stash and current_target is CharacterController.ItemInteraction and current_target.interaction_type == CharacterController.ItemInteraction.InteractionType.GIVE:
		_player_interaction_channel.raise(current_target)
	return Status.SUCCESS
