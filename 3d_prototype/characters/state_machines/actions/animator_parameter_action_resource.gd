class_name AnimatorParameterActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return AnimatorParameterAction.new()


class AnimatorParameterAction extends StateAction:
	var _character_controller: CharacterController
	var _movement_stats: CharacterMovementStatsResource
	#var _animator: AnimationTree
	
	
	func awake(state_machine) -> void:
		_character_controller = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character_controller.movement_stats
	
	#func on_update(_delta: float) -> void:
	#	var normalised_speed := _character_controller.horizontal_movement_vector.length() / _movement_stats.move_speed
