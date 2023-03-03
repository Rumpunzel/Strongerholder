class_name ReadMovementActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadMovementAction.new()


class ReadMovementAction extends StateAction:
	var _character: Character
	
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
	
	
	func on_update(_delta: float) -> void:
		var horizonal_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var vertical_input := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		var input_vector = Vector2(horizonal_input, vertical_input)
		var current_camera: GameCamera = _character.get_viewport().get_camera()
		_character.movement_input = current_camera.get_adjusted_movement(input_vector).normalized()# * target_speed
		
		if Input.is_action_just_pressed("sprint"):
			_character.sprint_input = true
		elif Input.is_action_just_released("sprint"):
			_character.sprint_input = false
