class_name ReadMovementActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadMovementAction.new()


class ReadMovementAction extends StateAction:
	var _character: Character
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
	
	
	func on_update(_delta: float) -> void:
		_character.input_vector = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
		
		if Input.is_action_just_pressed("sprint"):
			_character.is_running = true
		if Input.is_action_just_released("sprint"):
			_character.is_running = false
