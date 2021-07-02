class_name IsHoldingJumpConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsHoldingJumpCondition.new()


class IsHoldingJumpCondition extends StateCondition:
	var _character_controller: CharacterController
	
	
	func awake(state_machine):
		_character_controller = state_machine.owner
	
	
	func _statement() -> bool:
		return _character_controller.jump_input
