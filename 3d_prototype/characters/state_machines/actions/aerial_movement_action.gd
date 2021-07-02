extends StateActionResource

func _create_action() -> StateAction:
	return AerialMovementAction.new()


class AerialMovementAction extends StateAction:
	var _character_controller: CharacterController
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character_controller = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character_controller.movement_stats
	
	func on_update(_delta: float) -> void:
		var move_speed := _character_controller.target_speed * _movement_stats.move_speed * _movement_stats.aerial_modifier
		
		_character_controller.horizontal_movement_vector.x = _character_controller.movement_input.x * move_speed
		_character_controller.horizontal_movement_vector.y = _character_controller.movement_input.z * move_speed
