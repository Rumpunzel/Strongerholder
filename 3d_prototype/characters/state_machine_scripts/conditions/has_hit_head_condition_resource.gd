class_name HasHitHeadConditionResource
extends StateConditionResource

func create_condition() -> StateCondition:
	return HasHitHeadCondition.new()


class HasHitHeadCondition extends StateCondition:
	var _character: Character
	var _inputs: CharacterMovementInputs
	var _actions: CharacterMovementActions
	
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
		_inputs = Utils.find_node_of_type_in_children(_character, CharacterMovementInputs, true)
		_actions = Utils.find_node_of_type_in_children(_character, CharacterMovementActions, true)
	
	
	func _statement() -> bool:
		if _actions.vertical_velocity <= 0.0 or not _character.is_on_ceiling():
			return false
		
		_inputs.jump_input = false
		_actions.vertical_velocity = 0.0
		
		return true
