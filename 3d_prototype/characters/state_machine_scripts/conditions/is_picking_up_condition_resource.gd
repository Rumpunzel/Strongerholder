class_name IsPickingUpConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsPickingUpCondition.new()


class IsPickingUpCondition extends StateCondition:
	var _interaction_area: InteractionArea
	
	
	func awake(state_machine):
		var character: Character = state_machine.owner
		_interaction_area = character.get_interaction_area()
	
	
	func _statement() -> bool:
		if not _interaction_area.current_interaction or not _interaction_area.current_interaction.type == InteractionArea.InteractionType.PICK_UP:
			return false
		
		_interaction_area.current_interaction.type = InteractionArea.InteractionType.NONE
		return true
