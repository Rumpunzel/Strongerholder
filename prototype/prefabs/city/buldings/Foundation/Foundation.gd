tool
extends Spatial
class_name Foundation

func is_class(type): return type == "Foundation" or .is_class(type)
func get_class(): return "Foundation"


onready var build_point = get_parent()
onready var structure = $block setget , get_structure
onready var area = $area setget , get_area


var ring_vector:RingVector setget set_ring_vector, get_ring_vector

var gui setget set_gui, get_gui



# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", build_point, "entered")
	area.connect("body_exited", build_point, "exited")



func handle_highlighted(new_material):
	get_node("block").material_override = new_material


func interact(_sender:GameObject, _action:String) -> bool:
	gui.show_build_menu(build_point)
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
