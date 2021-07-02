class_name IsGroundedConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsGroundedCondition.new()


class IsGroundedCondition extends StateCondition:
	var _character_controller: CharacterController
	
	
	func awake(state_machine):
		_character_controller = state_machine.owner
	
	
	func _statement() -> bool:
		return _character_controller.is_grounded
