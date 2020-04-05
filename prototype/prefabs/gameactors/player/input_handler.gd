extends PuppetMaster



func get_input() -> Array:
	var commands:Array = [ ]
	
	if Input.is_action_pressed("interact"):
		commands.append(InteractCommand.new())
		get_tree().set_input_as_handled()
	
	var movement_vector:Vector3 = Vector3(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("jump"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands
