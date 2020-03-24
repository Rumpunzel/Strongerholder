extends GameActor
class_name NPC



# Called when the node enters the scene tree for the first time.
func _ready():
	pathfinder.register_actor(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

