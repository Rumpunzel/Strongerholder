class_name ReadJumpActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadJumpAction.new()


class ReadJumpAction extends StateAction:
	var _inputs: CharacterMovementInputs
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inputs = character.get_inputs()
	
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_pressed("jump"):
			_inputs.jump_input = true
		if Input.is_action_just_released("jump"):
			_inputs.jump_input = false
