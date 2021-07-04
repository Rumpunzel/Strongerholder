class_name IsMovingToPointConditionResource
extends StateConditionResource

export var _minimum_distance: float = 0.02
export var _override_speed_threshold: float = 0.2

func create_condition() -> StateCondition:
	return IsMovingToPointCondition.new(_minimum_distance, _override_speed_threshold)


class IsMovingToPointCondition extends StateCondition:
	var _character: Character
	var _inputs: CharacterMovementInputs
	var _minimum_distance: float
	var _override_speed_threshold: float
	
	
	func _init(minimum_distance: float, override_speed_threshold: float):
		_minimum_distance = minimum_distance
		_override_speed_threshold = override_speed_threshold
	
	
	func awake(state_machine):
		_character = state_machine.owner
		_inputs = _character.get_inputs()
	
	
	func _statement() -> bool:
		if _inputs.movement_input.length_squared() > _override_speed_threshold:
			return false
		
		var destination: Vector3 = _inputs.destination_input
		var distance: Vector3 = destination - _character.translation
		
		return distance.length_squared() > _minimum_distance
