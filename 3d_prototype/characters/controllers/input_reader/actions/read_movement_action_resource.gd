class_name ReadMovementActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadMovementAction.new()


class ReadMovementAction extends StateAction:
	var _character: Character
	var _inputs: CharacterMovementInputs
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_inputs = _character.get_inputs()
	
	
	func on_update(_delta: float) -> void:
		var horizonal_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var vertical_input := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		var input_vector = Vector2(horizonal_input, vertical_input)
		var current_camera: GameCamera = _character.get_viewport().get_camera()
		_inputs.movement_input = current_camera.get_adjusted_movement(input_vector).normalized()# * target_speed
		
		if Input.is_action_just_pressed("sprint"):
			_inputs.is_running = true
		if Input.is_action_just_released("sprint"):
			_inputs.is_running = false
