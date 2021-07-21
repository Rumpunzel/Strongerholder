class_name DescendActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return DescendAction.new()


class DescendAction extends StateAction:
	var _inputs: CharacterMovementInputs
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	
	var _gravity_magnitude: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	var _vertical_velocity: float
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inputs = Utils.find_node_of_type_in_children(character, CharacterMovementInputs)
		_actions = Utils.find_node_of_type_in_children(character, CharacterMovementActions)
		# warning-ignore:unsafe_property_access
		_movement_stats = character.movement_stats
	
	func on_state_enter():
		_vertical_velocity = _actions.vertical_velocity
		_inputs.jump_input = false
	
	func on_update(delta: float) -> void:
		_vertical_velocity -= _gravity_magnitude * _movement_stats.gravity_descend_multilpier * delta
		_actions.vertical_velocity = _vertical_velocity
