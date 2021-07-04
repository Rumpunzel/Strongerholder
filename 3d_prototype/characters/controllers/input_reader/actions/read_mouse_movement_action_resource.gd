class_name ReadMouseMovementActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadMouseMovementAction.new()


class ReadMouseMovementAction extends StateAction:
	var _navigation: Navigation
	var _inputs: CharacterMovementInputs
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_navigation = character.get_navigation()
		_inputs = character.get_inputs()
	
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_pressed("mouse_movement"):
			_inputs.getting_point_from_mouse = true
		if Input.is_action_just_released("mouse_movement"):
			_inputs.getting_point_from_mouse = false
