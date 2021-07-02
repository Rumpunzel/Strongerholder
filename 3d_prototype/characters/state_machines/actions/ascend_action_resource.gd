class_name AscendActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return AscendAction.new()


class AscendAction extends StateAction:
	var _character_controller: CharacterController
	var _movement_stats: CharacterMovementStatsResource
	
	var _gravity_magnitude: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	var _vertical_velocity: float
	
	
	func awake(state_machine) -> void:
		_character_controller = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character_controller.movement_stats
	
	func on_state_enter():
		_vertical_velocity = sqrt(_movement_stats.jump_height * 3.0 * _gravity_magnitude * _movement_stats.gravity_ascend_multiplier)
	
	func on_update(delta: float) -> void:
		_vertical_velocity -= _gravity_magnitude * _movement_stats.gravity_ascend_multiplier * delta
		_character_controller.vertical_velocity = _vertical_velocity
