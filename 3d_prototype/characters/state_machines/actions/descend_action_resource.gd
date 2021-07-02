class_name DescendActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return DescendAction.new()


class DescendAction extends StateAction:
	var _character_controller: CharacterController
	var _movement_stats: CharacterMovementStatsResource
	
	var _gravity_magnitude: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	var _vertical_velocity: float
	
	
	func awake(state_machine) -> void:
		_character_controller = state_machine.owner
		# warning-ignore:unsafe_property_access
		_movement_stats = _character_controller.movement_stats
	
	func on_state_enter():
		_vertical_velocity = _character_controller.vertical_velocity
		_character_controller.jump_input = false
	
	func on_update(delta: float) -> void:
		_vertical_velocity -= _gravity_magnitude * _movement_stats.gravity_descend_multilpier * delta
		_character_controller.vertical_velocity = _vertical_velocity