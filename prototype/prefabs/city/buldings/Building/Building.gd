tool
extends Spatial
class_name Building

func is_class(type): return type == "Building" or .is_class(type)
func get_class(): return "Building"


onready var structure = $block setget , get_structure
onready var area = $area setget , get_area


var ring_vector:Vector2 = Vector2() setget set_ring_vector, get_ring_vector



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func handle_highlighted(new_material):
	get_node("block").material_override = new_material


func interact(_sender:GameObject, _action:String):
	GUI.show_build_menu(get_parent())



func set_ring_vector(new_vector:Vector2):
	ring_vector = new_vector



func get_ring_vector() -> Vector2:
	return ring_vector


func get_structure():
	return structure


func get_area() -> Area:
	return area
