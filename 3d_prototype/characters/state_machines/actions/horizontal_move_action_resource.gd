class_name HorizontalMoveActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return HorizontalMoveAction.new()


class HorizontalMoveAction extends StateAction:
	var _inputs: CharacterMovementInputs
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inputs = character.get_inputs()
		_actions = character.get_actions()
		# warning-ignore:unsafe_property_access
		_movement_stats = character.movement_stats
	
	func on_update(_delta: float) -> void:
		var move_speed = _actions.target_speed * _movement_stats.move_speed
		
		_actions.horizontal_movement_vector.x = _inputs.movement_input.x * move_speed
		_actions.horizontal_movement_vector.y = _inputs.movement_input.z * move_speed
