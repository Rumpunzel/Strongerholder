class_name IsActuallyMovingToPointConditionResource
extends StateConditionResource

export var _threshold: float = 0.02

func create_condition() -> StateCondition:
	return IsActuallyMovingToPointCondition.new(_threshold)


class IsActuallyMovingToPointCondition extends StateCondition:
	var _threshold: float
	var _character_controller: CharacterController
	
	func _init(threshold: float):
		_threshold = threshold
	
	func awake(state_machine):
		_character_controller = state_machine.owner
