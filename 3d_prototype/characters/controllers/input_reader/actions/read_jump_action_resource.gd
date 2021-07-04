class_name ReadJumpActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadJumpAction.new()


class ReadJumpAction extends StateAction:
	var _character: Character
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_pressed("jump"):
			_character.jump_input = true
		if Input.is_action_just_released("jump"):
			_character.jump_input = false
