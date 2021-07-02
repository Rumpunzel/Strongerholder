class_name IsActuallyMovingConditionResource
extends StateConditionResource

export var _threshold: float = 0.02

func create_condition() -> StateCondition:
	return IsActuallyMovingCondition.new(_threshold)


class IsActuallyMovingCondition extends StateCondition:
	var _threshold: float
	var _character_controller: CharacterController
	
	
	func _init(threshold: float):
		_threshold = threshold
	
	
	func awake(state_machine):
		_character_controller = state_machine.owner
	
	
	func _statement() -> bool:
		return _character_controller.velocity.length_squared() > _threshold * _threshold
