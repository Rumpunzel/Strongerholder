extends Spatial
class_name CityObject

func is_class(class_type): return class_type == "CityObject" or .is_class(class_type)
func get_class(): return "CityObject"


export(NodePath) var structure_node
export(NodePath) var area_node


onready var structure = get_node(structure_node) setget , get_structure
onready var area = get_node(area_node) setget , get_area


var game_object

var ring_vector:RingVector setget set_ring_vector, get_ring_vector



# Called when the node enters the scene tree for the first time.
func _ready():
	game_object = get_parent()
	look_at(Vector3(0, transform.origin.y, 0), Vector3.UP)



func handle_highlighted(_new_material:Material):
	assert(false)

func interact(_sender:GameObject) -> bool:
	assert(false)
	return true



func set_ring_vector(new_vector:RingVector):
	ring_vector = new_vector
	
	global_transform.origin = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius).rotated(Vector3.UP, ring_vector.rotation)
	look_at(Vector3(0, transform.origin.y, 0), Vector3.UP)


func get_ring_vector() -> RingVector:
	return ring_vector

func get_structure():
	return structure

func get_area() -> Area:
	return area
