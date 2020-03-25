extends Node
class_name PuppetMaster

func is_class(type): return type == "PuppetMaster" or .is_class(type)
func get_class(): return "PuppetMaster"


var current_actors:Array = [ ] setget set_current_actors, get_current_actors



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	if not current_actors.empty():
		var commands:Array = get_input()
		
		for command in commands:
			for actor in current_actors:
				command.execute(actor)



func get_input() -> Array:
	assert(false)
	return [ ]


func register_actor(new_actor, exclusive_actor:bool = true):
	if exclusive_actor:
		current_actors = [ ]
	
	current_actors.append(new_actor)


func remove_actor(new_actor):
	current_actors.erase(new_actor)



func set_current_actors(new_actors:Array):
	current_actors = new_actors



func get_current_actors() -> Array:
	return current_actors




class Command:
	func execute(_actor):
		assert(false)


class MoveCommand extends Command:
	var movement_vector:Vector2
	var sprinting:bool
	
	func _init(new_movement_vector:Vector2, new_sprinting:bool):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func execute(actor:GameActor):
		actor.move_to(movement_vector, sprinting)


class JumpCommand extends Command:
	func execute(actor:GameActor):
		actor.jump()
