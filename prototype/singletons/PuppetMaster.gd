extends Node
class_name PuppetMaster


var current_actor:GameActor = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	if current_actor:
		var command:Command = get_input()
		
		if command:
			command.execute(current_actor)



func get_input() -> Command:
	assert(false)
	return null



class Command:
	func execute(_actor:GameActor):
		assert(false)
	
	func undo(_actor:GameActor):
		pass


class MoveCommand extends Command:
	var previous_ring_vector:Vector2 = Vector2()
	var ring_vector:Vector2
	var sprinting:bool
	
	func _init(new_ring_vector:Vector2, new_sprinting:bool):
		ring_vector = new_ring_vector
		sprinting = new_sprinting
		
	func execute(actor:GameActor):
		previous_ring_vector = actor.ring_vector
		actor.move_to(ring_vector, sprinting)
	
	func undo(actor:GameActor):
		actor.move_to(previous_ring_vector, sprinting)


class JumpCommand extends Command:
	func execute(actor:GameActor):
		actor.jump()
