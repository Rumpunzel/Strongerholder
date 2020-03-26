extends Spatial
class_name Hill

func is_class(type): return type == "Hill" or .is_class(type)
func get_class(): return "Hill"


const NUMBER_OF_RINGS:int = 10



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
