tool
extends PathFinder



func _unhandled_input(event):
	if not current_actors.empty():
		var commands:Array = [ ]
		
		if event.is_action_released("interact"):
			commands.append(InteractCommand.new())
		
		if event.is_action_pressed("jump"):
			commands.append(JumpCommand.new())
		
#		if event.is_action_released("jump"):
#			commands.append(StopJumpCommand.new())
		
		if not commands.empty():
			get_tree().set_input_as_handled()
		
		for actor in current_actors:
			for command in commands:
				if command.execute(actor):
					break



func get_input() -> Array:
	var commands:Array = [ ]
	
	var movement_vector:Vector2 = Vector2(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands




class StopJumpCommand extends PuppetMaster.Command:
	func execute(actor:GameActor) -> bool:
		actor.stop_jump()
		return false


class InteractCommand extends PuppetMaster.Command:
	func execute(actor:GameActor) -> bool:
		return actor.interact_with_object()
