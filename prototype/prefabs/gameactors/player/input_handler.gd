extends PuppetMaster



func _unhandled_input(event):
	var commands:Array = [ ]
	
	if event.is_action_released("interact"):
		commands.append(InteractCommand.new())
	
	if not commands.empty():
		get_tree().set_input_as_handled()
		emit_signal("new_commands", commands)



func get_input() -> Array:
	var commands:Array = [ ]
	
	var movement_vector:Vector3 = Vector3(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("jump"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands
