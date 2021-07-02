class_name IsPickingUpConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsPickingUpCondition.new()


class IsPickingUpCondition extends StateCondition:
	var _interaction_manager
	
	
	func awake(state_machine):
		_interaction_manager = state_machine.owner
	
	
	func _statement() -> bool:
		#if not _interaction_manager.current_interaction or not _interaction_manager.current_interaction.type == InteractionManager.InteractionType.Attack:
		#	return false
		
		#_interaction_manager.current_interaction.type = InteractionManager.InteractionType.None
		return false
