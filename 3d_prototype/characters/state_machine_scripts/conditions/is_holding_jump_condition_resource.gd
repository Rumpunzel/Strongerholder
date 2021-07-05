class_name IsHoldingJumpConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsHoldingJumpCondition.new()


class IsHoldingJumpCondition extends StateCondition:
	var _inputs: CharacterMovementInputs
	
	
	func awake(state_machine):
		var character: Character = state_machine.owner
		_inputs = character.get_inputs()
	
	func _statement() -> bool:
		return _inputs.jump_input
