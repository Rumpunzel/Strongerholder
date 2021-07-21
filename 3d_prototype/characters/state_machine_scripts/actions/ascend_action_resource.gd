class_name AscendActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return AscendAction.new()


class AscendAction extends StateAction:
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	
	var _gravity_magnitude: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	var _vertical_velocity: float
	
	
	func awake(state_machine: Node) -> void:
		var character: Character = state_machine.owner
		_actions = Utils.find_node_of_type_in_children(character, CharacterMovementActions, true)
		# warning-ignore:unsafe_property_access
		_movement_stats = character.movement_stats
	
	func on_state_enter():
		_vertical_velocity = sqrt(_movement_stats.jump_height * 3.0 * _gravity_magnitude * _movement_stats.gravity_ascend_multiplier)
	
	func on_update(delta: float) -> void:
		_vertical_velocity -= _gravity_magnitude * _movement_stats.gravity_ascend_multiplier * delta
		_actions.vertical_velocity = _vertical_velocity
