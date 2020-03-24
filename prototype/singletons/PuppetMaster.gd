extends Node
class_name PuppetMaster


var current_actors:Array = [ ]



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	var commands:Array = get_input()
	
	for command in commands:
		for actor in current_actors:
			command.execute(actor)



func get_input() -> Array:
	assert(false)
	return [ ]


func register_actor(new_actor:GameActor, exclusive_actor:bool = true):
	if exclusive_actor:
		current_actors = [ ]
	
	current_actors.append(new_actor)



class Command:
	func execute(_actor:GameActor):
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
