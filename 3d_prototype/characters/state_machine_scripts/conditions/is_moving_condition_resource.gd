class_name IsMovingConditionResource
extends StateConditionResource

export var _threshold: float = 0.02
export var _override_speed_threshold: float = 0.2

func create_condition() -> StateCondition:
	return IsMovingCondition.new(_threshold, _override_speed_threshold)


class IsMovingCondition extends StateCondition:
	var _character: Character
	var _navigation_agent: NavigationAgent
	var _actions: CharacterMovementActions
	
	var _threshold: float
	var _override_speed_threshold: float
	
	
	func _init(threshold: float, override_speed_threshold: float):
		_threshold = threshold
		_override_speed_threshold = override_speed_threshold
	
	
	func awake(state_machine: Node):
		_character = state_machine.owner
		_navigation_agent = _character.get_navigation_agent()
		_actions = Utils.find_node_of_type_in_children(_character, CharacterMovementActions, true)
	
	
	func _statement() -> bool:
		var movement_vector: Vector3 = _character.movement_input
		movement_vector.y = 0.0
		var movement_length := movement_vector.length_squared()
		
		if movement_length < _override_speed_threshold:
			var destination: Vector3 = _character.destination_input
			destination.y = 0.0
			var character_position := _character.translation
			character_position.y = 0.0
			var distance: Vector3 = destination - character_position
			
			if distance.length_squared() > _navigation_agent.target_desired_distance:
				_actions.moving_to_destination = true
				return true
		
		
		_character.destination_input = _character.translation
		_actions.moving_to_destination = false
		return movement_length > _threshold
