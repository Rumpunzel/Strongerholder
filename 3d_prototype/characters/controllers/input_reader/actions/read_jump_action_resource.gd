class_name ReadJumpActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadJumpAction.new()


class ReadJumpAction extends StateAction:
	var _character: Character
	var _inputs: CharacterMovementInputs
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_inputs = Utils.find_node_of_type_in_children(_character, CharacterMovementInputs)
	
	
	func on_input(input: InputEvent) -> void:
		if input.is_action_pressed("jump"):
			_inputs.jump_input = true
			_character.get_tree().set_input_as_handled()
		elif input.is_action_released("jump"):
			_inputs.jump_input = false
			_character.get_tree().set_input_as_handled()
