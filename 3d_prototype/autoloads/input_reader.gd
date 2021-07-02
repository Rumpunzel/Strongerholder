extends Node

var listener


func _process(_delta: float):
	if listener:
		_delegate_inputs()


func _delegate_inputs() -> void:
	listener.input_vector = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	if Input.is_action_just_pressed("sprint"):
		listener.is_running = true
	if Input.is_action_just_released("sprint"):
		listener.is_running = false
	
	if Input.is_action_just_pressed("jump"):
		listener.jump_input = true
	if Input.is_action_just_released("jump"):
		listener.jump_input = false
