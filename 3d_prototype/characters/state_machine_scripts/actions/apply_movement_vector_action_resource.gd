class_name ApplyMovementVectorActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ApplyMovementVectorAction.new()


class ApplyMovementVectorAction extends StateAction:
	var _character: Character
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_actions = Utils.find_node_of_type_in_children(_character, CharacterMovementActions)
		# warning-ignore:unsafe_property_access
		_movement_stats = _character.movement_stats
	
	func on_update(delta: float) -> void:
		var horizontal_movement: Vector2
		
		if _actions.moving_to_destination:
			if _actions.on_path():
				var destination := _actions.next_path_point()
				var direction := destination - _character.translation
				direction.y = _character.translation.y
				var direction_length := direction.length()
				var step_size: float = _movement_stats.move_speed
				
				if direction_length < step_size * delta:
					_actions.reached_point()
				
				horizontal_movement = Vector2(direction.normalized().x, direction.normalized().z) * step_size
			else:
				horizontal_movement = Vector2.ZERO
		else:
			horizontal_movement = _actions.horizontal_movement_vector
		
		
		var new_movement_vector := Vector3(
				horizontal_movement.x,
				_actions.vertical_velocity,
				horizontal_movement.y
		)
		
		_character.velocity = new_movement_vector
		
		if not horizontal_movement == Vector2.ZERO:
			_character.look_position = new_movement_vector * 100.0 + _character.translation
