extends GameActor
class_name NPC

func is_class(type): return type == "NPC" or .is_class(type)
func get_class(): return "NPC"


# Called when the node enters the scene tree for the first time.
func _ready():
	pathfinder.register_actor(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

