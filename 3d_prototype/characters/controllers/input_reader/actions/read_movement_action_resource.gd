class_name ReadMovementActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadMovementAction.new()


class ReadMovementAction extends StateAction:
	var _inputs: CharacterMovementInputs
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_inputs = character.get_inputs()
	
	
	func on_update(_delta: float) -> void:
		var horizonal_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var vertical_input := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		_inputs.input_vector = Vector2(horizonal_input, vertical_input)
		
		if Input.is_action_just_pressed("sprint"):
			_inputs.is_running = true
		if Input.is_action_just_released("sprint"):
			_inputs.is_running = false
