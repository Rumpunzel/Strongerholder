class_name ClearInputCachOnEnterResource
extends StateActionResource

func _create_action() -> StateAction:
	return ClearInputCachOnEnter.new()


class ClearInputCachOnEnter extends StateAction:
	var _inputs: CharacterMovementInputs
	var _interaction_area: InteractionArea
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inputs = character.get_inputs()
	
	func on_state_enter():
		_inputs.jump_input = false
		_interaction_area.current_interaction = null
