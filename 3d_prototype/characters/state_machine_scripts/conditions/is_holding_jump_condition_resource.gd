class_name IsHoldingJumpConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsHoldingJumpCondition.new()


class IsHoldingJumpCondition extends StateCondition:
	var _character: Character
	
	func awake(state_machine: Node):
		_character = state_machine.owner
	
	func _statement() -> bool:
		return _character.jump_input
