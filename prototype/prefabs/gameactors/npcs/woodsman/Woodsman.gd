extends NPC
class_name Woodsman

func is_class(type): return type == "Woodsman" or .is_class(type)
func get_class(): return "Woodsman"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_pathfinding_target(Vector2(2, 9))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
