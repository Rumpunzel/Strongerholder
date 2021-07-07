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
	
	
	func enter_state() -> void:
		_inputs.movement_input = Vector3.ZERO
	
	func on_update(_delta: float) -> void:
		if Input.is_action_pressed("mouse_movement"):
			var camera_ray := CameraSystem.mouse_as_world_point()
			var navigation_point := _navigation.get_closest_point_to_segment(camera_ray.from, camera_ray.to)
			
			# HACK: fixed Navigation always returning a point 0.4 over ground
			navigation_point.y = 0.0
			_inputs.destination_input = navigation_point
