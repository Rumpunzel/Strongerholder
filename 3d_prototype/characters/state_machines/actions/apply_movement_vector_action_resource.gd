class_name ApplyMovementVectorActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ApplyMovementVectorAction.new()


class ApplyMovementVectorAction extends StateAction:
	var _character_controller: CharacterController
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character_controller = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character_controller.movement_stats
	
	func on_update(_delta: float) -> void:
		var horizontal_movement := _character_controller.horizontal_movement_vector
		var new_movement_vector := Vector3(
				horizontal_movement.x,
				_character_controller.vertical_velocity,
				horizontal_movement.y
		)
		
		_character_controller.velocity = new_movement_vector
		
		if not horizontal_movement == Vector2.ZERO:
			var look_at := _character_controller.transform.origin - Vector3(horizontal_movement.x, 0.0, horizontal_movement.y)
			# TODO: add smooth rotation
			_character_controller.look_at(look_at, Vector3.UP)
