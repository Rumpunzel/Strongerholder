class_name IsInteractingConditionResource
extends StateConditionResource

export(InteractionArea.InteractionType) var interaction_type

func create_condition() -> StateCondition:
	return IsInteractingCondition.new()


class IsInteractingCondition extends StateCondition:
	var _interaction_area: InteractionArea
	
	
	func awake(state_machine: Node):
		var character: Character = state_machine.owner
		_interaction_area = Utils.find_node_of_type_in_children(character, InteractionArea)
	
	
	func _statement() -> bool:
		# warning-ignore:unsafe_property_access
		if not _interaction_area.current_interaction or not _interaction_area.current_interaction.type == origin_resource.interaction_type:
			return false
		
		_interaction_area.current_interaction.type = InteractionArea.InteractionType.NONE
		return true
