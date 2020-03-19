tool
extends GameObject
class_name BuildingFundament


onready var body = $block setget set_body, get_body


var ring:int setget set_ring, get_ring
var segment:int setget set_segment, get_segment



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func set_ring_position(new_position:Vector3):
	body.transform.origin = new_position

func calculate_distance_to_center() -> float:
	return body.global_transform.origin.distance_to(Vector3())


func handle_highlighted():
	body.rotation.z = (PI / 2.0) if highlighted else 0.0


func world_position():
	return body.global_transform.origin


func set_body(new_body):
	body = new_body

func set_ring(new_ring:int):
	ring = new_ring

func set_segment(new_segment:int):
	segment = new_segment


func get_body():
	return body

func get_ring() -> int:
	return ring

func get_segment() -> int:
	return segment
