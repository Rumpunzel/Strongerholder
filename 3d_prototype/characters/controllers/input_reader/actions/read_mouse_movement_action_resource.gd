class_name ReadMouseMovementActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadMouseMovementAction.new()


class ReadMouseMovementAction extends StateAction:
	var _character: Character
	var _navigation: Navigation
	
	
	func awake(state_machine) -> void:
		_character = state_machine.owner
		_navigation = _character.navigation
	
	
	func on_update(_delta: float) -> void:
		if Input.is_action_just_pressed("mouse_movement"):
			#_getting_point_from_mouse = true
			_character.destination_input = CameraSystem.mouse_as_world_point(_navigation)
		if Input.is_action_just_released("mouse_movement"):
			pass#_getting_point_from_mouse = false
