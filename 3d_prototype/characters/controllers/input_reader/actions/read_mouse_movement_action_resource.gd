class_name ReadMouseMovementActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadMouseMovementAction.new()


class ReadMouseMovementAction extends StateAction:
	var _character: Character
	var _navigation: Navigation
	var _inputs: CharacterMovementInputs
	
	var _moving_to_point := false
	
	
	func awake(state_machine: Node) -> void:
		_character = state_machine.owner
		_navigation = _character.get_navigation()
		_inputs = Utils.find_node_of_type_in_children(state_machine, CharacterMovementInputs)
	
	
	func enter_state() -> void:
		_inputs.movement_input = Vector3.ZERO
	
	
	func on_update(_delta: float) -> void:
		if _moving_to_point:
			var current_camera: GameCamera = _character.get_viewport().get_camera()
			var camera_ray := current_camera.mouse_as_world_point()
			var navigation_point := _navigation.get_closest_point_to_segment(camera_ray.from, camera_ray.to)
			
			# HACK: fixed Navigation always returning a point 0.4 over ground
			navigation_point.y = 0.0
			_inputs.destination_input = navigation_point
	
	
	func on_input(input: InputEvent) -> void:
		if input.is_action_pressed("mouse_movement"):
			_moving_to_point = true
			_character.get_tree().set_input_as_handled()
		elif input.is_action_released("mouse_movement"):
			_moving_to_point = false
			_character.get_tree().set_input_as_handled()
