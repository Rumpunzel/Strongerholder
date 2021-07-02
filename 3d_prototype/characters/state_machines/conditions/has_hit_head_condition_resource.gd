class_name HasHitHeadConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return HasHitHeadCondition.new()


class HasHitHeadCondition extends StateCondition:
	var _character_controller: CharacterController
	
	
	func awake(state_machine):
		_character_controller = state_machine.owner
	
	
	func _statement() -> bool:
		if _character_controller.vertical_velocity <= 0.0 or not _character_controller.is_on_ceiling():
			return false
		
		_character_controller.jump_input = false
		_character_controller.vertical_velocity = 0.0
		
		return true
