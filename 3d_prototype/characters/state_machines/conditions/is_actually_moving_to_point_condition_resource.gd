class_name IsActuallyMovingToPointConditionResource
extends StateConditionResource

#export 
var _threshold: float = 0.02

func create_condition() -> StateCondition:
	return IsActuallyMovingToPointCondition.new(_threshold)


class IsActuallyMovingToPointCondition extends StateCondition:
	var _character: Character
	var _actions: CharacterMovementActions
	var _threshold: float
	
	
	func _init(threshold: float):
		_threshold = threshold
	
	
	func awake(state_machine):
		_character = state_machine.owner
		_actions = _character.get_actions()
	
	func _statement() -> bool:
		print(_actions.next_path_point())
		return _character.velocity.length_squared() > _threshold * _threshold
