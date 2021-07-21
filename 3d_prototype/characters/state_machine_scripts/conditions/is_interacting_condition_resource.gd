class_name IsInteractingConditionResource
extends StateConditionResource

export(InteractionArea.InteractionType) var _interaction_type

func create_condition() -> StateCondition:
	return IsInteractingCondition.new(_interaction_type)


class IsInteractingCondition extends StateCondition:
	var _interaction_area: InteractionArea
	
	var _interaction_type: int
	
	
	func _init(interaction_type: int) -> void:
		_interaction_type = interaction_type
	
	
	func awake(state_machine: Node):
		var character: Character = state_machine.owner
		_interaction_area = Utils.find_node_of_type_in_children(character, InteractionArea)
	
	
	func _statement() -> bool:
		if not _interaction_area.current_interaction or not _interaction_area.current_interaction.type == _interaction_type:
			return false
		
		_interaction_area.current_interaction.type = InteractionArea.InteractionType.NONE
		return true
