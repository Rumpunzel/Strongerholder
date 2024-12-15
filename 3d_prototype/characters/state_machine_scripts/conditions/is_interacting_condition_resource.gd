class_name IsInteractingConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return IsInteractingCondition.new()


class IsInteractingCondition extends StateCondition:
	var _character: CharacterController
	
	func awake(state_machine: Node):
		_character = state_machine.owner
	
	func _statement() -> bool:
		var current_interaction: CharacterController.Target = _character.current_interaction
		if not current_interaction:
			return false
		
		_character.current_interaction = CharacterController.Target.new(current_interaction.node)
		return true
