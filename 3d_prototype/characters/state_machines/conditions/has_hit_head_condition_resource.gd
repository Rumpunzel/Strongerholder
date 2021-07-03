class_name HasHitHeadConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return HasHitHeadCondition.new()


class HasHitHeadCondition extends StateCondition:
	var _character: Character
	
	
	func awake(state_machine):
		_character = state_machine.owner
	
	
	func _statement() -> bool:
		if _character.vertical_velocity <= 0.0 or not _character.is_on_ceiling():
			return false
		
		_character.jump_input = false
		_character.vertical_velocity = 0.0
		
		return true
