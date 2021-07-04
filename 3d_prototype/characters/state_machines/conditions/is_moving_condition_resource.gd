class_name IsMovingConditionResource
extends StateConditionResource

export var _threshold: float = 0.02

func create_condition() -> StateCondition:
	return IsMovingCondition.new(_threshold)


class IsMovingCondition extends StateCondition:
	var _inputs: CharacterMovementInputs
	var _threshold: float
	
	
	func _init(threshold: float):
		_threshold = threshold
	
	
	func awake(state_machine):
		var character: Character = state_machine.owner
		_inputs = character.get_inputs()
	
	func _statement() -> bool:
		var movement_vector: Vector3 = _inputs.movement_input
		movement_vector.y = 0.0
		
		return movement_vector.length_squared() > _threshold
