tool
extends Spatial
class_name CityObject

func is_class(type): return type == "CityObject" or .is_class(type)
func get_class(): return "CityObject"


export(NodePath) var structure_node
export(NodePath) var area_node


onready var structure = get_node(structure_node) setget , get_structure
onready var area = get_node(area_node) setget , get_area


var game_object

var ring_vector:RingVector setget set_ring_vector, get_ring_vector

var gui setget set_gui, get_gui



# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	
	game_object = get_parent()
	
	area.connect("body_entered", game_object, "entered")
	area.connect("body_exited", game_object, "exited")



func handle_highlighted(_new_material:Material):
	assert(false)


func interact(_sender:GameObject, _action:String) -> bool:
	assert(false)
	return true




func set_ring_vector(new_vector:RingVector):
	ring_vector = new_vector


func set_gui(new_gui):
	gui = new_gui



func get_ring_vector() -> RingVector:
	return ring_vector


func get_gui():
	return gui


func get_structure():
	return structure


func get_area() -> Area:
	return area
