class_name IsInteractingConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsInteractingCondition.new()


class IsInteractingCondition extends StateCondition:
	var _character_controller: CharacterController
	
	func awake(state_machine: Node):
		var character: Character = state_machine.owner
		_character_controller = Utils.find_node_of_type_in_children(character, CharacterController)
	
	func _statement() -> bool:
		var current_interaction: CharacterController.Target = _character_controller.blackboard.current_interaction
		if not current_interaction:
			return false
		
		_character_controller.blackboard.current_interaction = CharacterController.Target(current_interaction.node)
		return true
