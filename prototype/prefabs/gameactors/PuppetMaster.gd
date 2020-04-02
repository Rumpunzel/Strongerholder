extends Node
class_name PuppetMaster

func is_class(type): return type == "PuppetMaster" or .is_class(type)
func get_class(): return "PuppetMaster"


var current_actor:GameActor = null setget set_current_actor, get_current_actor

var connected_signals:Array = [ ]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	if current_actor:
		var commands:Array = get_input()
		
		for command in commands:
			command.execute(current_actor)



func get_input() -> Array:
	assert(false)
	return [ ]


func register_actor(new_actor:GameActor):
	set_current_actor(new_actor)


func remove_actor(old_actor):
	if old_actor == current_actor:
		set_current_actor(null)
		
		for con_signal in connected_signals:
			con_signal.disconnect()



func set_current_actor(new_actor:GameActor):
	current_actor = new_actor



func get_current_actor() -> GameActor:
	return current_actor




class Command:
	func execute(_actor) -> bool:
		assert(false)
		return true


class MoveCommand extends Command:
	var movement_vector:Vector2
	var sprinting:bool
	
	func _init(new_movement_vector:Vector2, new_sprinting:bool):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func execute(actor:GameActor) -> bool:
		actor.move_to(movement_vector, sprinting)
		return false


class JumpCommand extends Command:
	func execute(actor:GameActor) -> bool:
		actor.jump()
		return false
