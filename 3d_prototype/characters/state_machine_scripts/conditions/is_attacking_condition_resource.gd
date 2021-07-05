class_name IsAttackingConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsAttackingCondition.new()


class IsAttackingCondition extends StateCondition:
	#var _interaction_area: InteractionArea
	
	
	#func awake(state_machine):
	#	pass#_interaction_area = state_machine.owner
	
	func _statement() -> bool:
		#if not _interaction_manager.current_interaction or not _interaction_manager.current_interaction.type == InteractionManager.InteractionType.Attack:
		#	return false
		
		#_interaction_manager.current_interaction.type = InteractionManager.InteractionType.None
		return false
