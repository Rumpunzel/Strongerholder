class_name IsActuallyMovingConditionResource
extends StateConditionResource

export var _threshold: float = 0.02

func create_condition() -> StateCondition:
	return IsActuallyMovingCondition.new(_threshold)


class IsActuallyMovingCondition extends StateCondition:
	var _threshold: float
	var _character: Character
	
	
	func _init(threshold: float):
		_threshold = threshold
	
	
	func awake(state_machine):
		_character = state_machine.owner
	
	
	func _statement() -> bool:
		return _character.velocity.length_squared() > _threshold * _threshold
