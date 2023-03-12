extends ActionLeaf

export var _input_deadzone_squated := 0.001

onready var _current_camera: GameCamera = get_viewport().get_camera()

func on_update(blackboard: CharacterController.CharacterBlackboard) -> int:
	var character := blackboard.character
	var horizonal_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var vertical_input := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var input_vector = Vector2(horizonal_input, vertical_input)
	
	character.movement_input = _current_camera.get_adjusted_movement(input_vector).normalized()# * target_speed
	
	if input_vector.length_squared() <= _input_deadzone_squated:
		return Status.FAILURE
	return Status.RUNNING
