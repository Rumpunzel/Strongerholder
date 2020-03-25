extends CommandPattern
class_name PuppetMaster



func register_actor(new_actor:GameActor, exclusive_actor:bool = true):
	.register_actor(new_actor, exclusive_actor)



class MoveCommand extends CommandPattern.Command:
	var movement_vector:Vector2
	var sprinting:bool
	
	func _init(new_movement_vector:Vector2, new_sprinting:bool):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func execute(actor:GameActor):
		actor.move_to(movement_vector, sprinting)


class JumpCommand extends CommandPattern.Command:
	func execute(actor:GameActor):
		actor.jump()
