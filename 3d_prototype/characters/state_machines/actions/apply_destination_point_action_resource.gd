class_name ApplyDestinationPointActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ApplyDestinationPointAction.new()


class ApplyDestinationPointAction extends StateAction:
	var _character: Character
	var _navigation: Navigation
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_navigation = _character.get_navigation()
		_actions = _character.get_actions()
		# warning-ignore:unsafe_property_access
		_movement_stats = _character.movement_stats
	
	func on_state_enter() -> void:
		_actions.path = _navigation.get_simple_path(_character.translation, _actions.destination_point, true)
	
	func on_update(delta: float) -> void:
		if not _actions.on_path():
			return
		
		var destination := _actions.next_path_point()
		var direction := destination - _character.translation
		direction.y = _character.translation.y
		var direction_length := direction.length()
		var step_size: float = _movement_stats.move_speed
		
		if direction_length < step_size * delta:
			_actions.reached_point()
		else:
			_character.velocity = direction.normalized() * step_size
		
		
		if not direction == Vector3.ZERO:
			var look_position := direction
			look_position.y = _character.translation.y
			var new_transform := _character.transform.looking_at(look_position, Vector3.UP)
			_character.transform  = _character.transform.interpolate_with(new_transform, _movement_stats.turn_rate * delta)
