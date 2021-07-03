class_name ApplyMovementVectorActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ApplyMovementVectorAction.new()


class ApplyMovementVectorAction extends StateAction:
	var _character: Character
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character.movement_stats
	
	func on_update(delta: float) -> void:
		var horizontal_movement := _character.horizontal_movement_vector
		var new_movement_vector := Vector3(
				horizontal_movement.x,
				_character.vertical_velocity,
				horizontal_movement.y
		)
		
		_character.velocity = new_movement_vector
		
		if not horizontal_movement == Vector2.ZERO:
			var look_position := -Vector3(horizontal_movement.x, 0.0, horizontal_movement.y) * 10.0
			var new_transform := _character.transform.looking_at(look_position, Vector3.UP)
			_character.transform  = _character.transform.interpolate_with(new_transform, _movement_stats.turn_rate * delta)
