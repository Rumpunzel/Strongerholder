class_name ClearInputCachOnEnterResource
extends StateActionResource

func _create_action() -> StateAction:
	return ClearInputCachOnEnter.new()


class ClearInputCachOnEnter extends StateAction:
	var _character: Character
	var _interaction_manager
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	func on_state_enter():
		_character.jump_input = false
		_interaction_manager.current_interaction = null
