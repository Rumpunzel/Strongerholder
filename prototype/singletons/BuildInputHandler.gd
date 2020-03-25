extends CommandPattern



func get_input() -> Array:
	var commands:Array = [ ]
	
	if Input.is_action_just_pressed("interact"):
		commands.append(BuildCommand.new())
	
	return commands



class BuildCommand extends CommandPattern.Command:
	func execute(actor):
		actor.stop_jump()
