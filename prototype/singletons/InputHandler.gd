extends PuppetMaster



func get_input() -> Array:
	var commands:Array = [ ]
	
	if Input.is_action_just_pressed("jump"):
		commands.append(JumpCommand.new())
	
	#if Input.is_action_just_released("jump"):
	#	commands.append(StopJumpCommand.new())
	
	var movement_vector:Vector2 = Vector2(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if movement_vector.length() > 0:
		var sprinting = Input.is_action_pressed("sprint")
		
		if movement_vector.length() > 1:
			movement_vector = movement_vector.normalized()
		
		commands.append(MoveCommand.new(movement_vector, sprinting))
	
	
	if Input.is_action_just_pressed("interact"):
		commands.append(BuildCommand.new())
	
	return commands




class StopJumpCommand extends PuppetMaster.Command:
	func _init():
		actor_class = "GameActor"
	
	func execute(actor:GameActor):
		actor.stop_jump()


class BuildCommand extends PuppetMaster.Command:
	func _init():
		actor_class = "CityStructures"
	
	func execute(actor:CityStructures):
		actor.initiate_build()
