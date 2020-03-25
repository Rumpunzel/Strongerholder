extends Node
class_name CommandPattern


var current_actors:Array = [ ]



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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



class Command:
	func execute(_actor):
		assert(false)
