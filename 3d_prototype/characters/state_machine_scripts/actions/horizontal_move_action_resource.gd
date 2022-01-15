class_name HorizontalMoveActionResource
extends StateActionResource

enum MovementType { ON_GROUND, IN_AIR }

export(MovementType) var _movement_type = MovementType.ON_GROUND

func _create_action() -> StateAction:
	return HorizontalMoveAction.new(_movement_type)


class HorizontalMoveAction extends StateAction:
	enum { ON_GROUND, IN_AIR }
	
	var _navigation_agent: NavigationAgent
	var _inputs: CharacterMovementInputs
	var _actions: CharacterMovementActions
	var _movement_stats: CharacterMovementStatsResource
	
	var _movement_type: int
	
	
	func _init(movement_type: int) -> void:
		_movement_type = movement_type
	
	
	func awake(state_machine: Node) -> void:
		var character: Character = state_machine.owner
		_navigation_agent = character.get_navigation_agent()
		_inputs = Utils.find_node_of_type_in_children(character, CharacterMovementInputs, true)
		_actions = Utils.find_node_of_type_in_children(character, CharacterMovementActions, true)
		# warning-ignore:unsafe_property_access
		_movement_stats = character.movement_stats
	
	func on_update(_delta: float) -> void:
		if _actions.moving_to_destination:
			_navigation_agent.set_target_location(_inputs.destination_input)
		else:
			var move_speed := _actions.target_speed * _movement_stats.move_speed
			if _movement_type == IN_AIR:
				move_speed *= _movement_stats.aerial_modifier
			
			_actions.horizontal_movement_vector.x = _inputs.movement_input.x * move_speed
			_actions.horizontal_movement_vector.y = _inputs.movement_input.z * move_speed
