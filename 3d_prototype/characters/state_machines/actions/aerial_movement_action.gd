extends StateActionResource

func _create_action() -> StateAction:
	return AerialMovementAction.new()


class AerialMovementAction extends StateAction:
	var _character: Character
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character.movement_stats
	
	func on_update(_delta: float) -> void:
		var move_speed := _character.target_speed * _movement_stats.move_speed * _movement_stats.aerial_modifier
		
		_character.horizontal_movement_vector.x = _character.movement_input.x * move_speed
		_character.horizontal_movement_vector.y = _character.movement_input.z * move_speed
