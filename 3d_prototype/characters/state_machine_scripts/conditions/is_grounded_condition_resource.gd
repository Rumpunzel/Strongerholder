class_name IsGroundedConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsGroundedCondition.new()


class IsGroundedCondition extends StateCondition:
	var _character: Character
	
	
	func awake(state_machine):
		_character = state_machine.owner
	
	func _statement() -> bool:
		return _character.is_grounded
