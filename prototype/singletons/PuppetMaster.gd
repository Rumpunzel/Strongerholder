extends Node
class_name PuppetMaster

func is_class(type): return type == "PuppetMaster" or .is_class(type)
func get_class(): return "PuppetMaster"


var current_actors:Array = [ ]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	if not current_actors.empty():
		var commands:Array = get_input()
		
		for command in commands:
			for actor in current_actors:
				if actor.is_class(command.actor_class) or command.actor_class == "":
					command.execute(actor)



func get_input() -> Array:
	assert(false)
	return [ ]


func register_actor(new_actor, exclusive_actor:bool = true):
	if exclusive_actor:
		current_actors = [ ]
	
	current_actors.append(new_actor)




class Command:
	var actor_class:String = "" setget , get_actor_class
	
	func execute(_actor):
		assert(false)
	
	func get_actor_class() -> String:
		return actor_class


class MoveCommand extends Command:
	var movement_vector:Vector2
	var sprinting:bool
	
	func _init(new_movement_vector:Vector2, new_sprinting:bool):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		actor_class = "GameActor"
		
	func execute(actor:GameActor):
		actor.move_to(movement_vector, sprinting)


class JumpCommand extends Command:
	func _init():
		actor_class = "GameActor"
	
	func execute(actor:GameActor):
		actor.jump()
