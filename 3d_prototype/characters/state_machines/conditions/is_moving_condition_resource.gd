class_name IsMovingConditionResource
extends StateConditionResource

export var _threshold: float = 0.02

func create_condition() -> StateCondition:
	return IsMovingCondition.new(_threshold)


class IsMovingCondition extends StateCondition:
	var _threshold: float
	var _character: Character
	
	
	func _init(threshold: float):
		_threshold = threshold
	
	
	func awake(state_machine):
		_character = state_machine.owner
	
	
	func _statement() -> bool:
		var movement_vector: Vector3 = _character.movement_input
		movement_vector.y = 0.0
		
		return movement_vector.length_squared() > _threshold
