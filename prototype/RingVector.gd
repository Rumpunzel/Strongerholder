extends Resource
class_name RingVector


var ring:int setget set_ring, get_ring
var segment:int setget set_segment, get_segment

var radius:float setget set_radius, get_radius
var rotation:float setget set_rotation, get_rotation


signal vector_changed



func _init(new_x, new_y, use_as_int_values:bool = false):
	if use_as_int_values:
		set_ring(int(new_x))
		set_segment(int(new_y))
	else:
		set_radius(float(new_x))
		set_rotation(float(new_y))
	
	recalcuate()


func _ready():
	emit_signal("vector_changed")


func recalcuate():
	var new_ring = RingMap.get_current_ring(radius)
	var new_segment = RingMap.get_current_segment(ring, rotation)
	
	if not new_ring == ring or not new_segment == segment:
		ring = new_ring
		segment = new_segment
		
		emit_signal("vector_changed")


func modulo_ring_vector():
	while rotation > PI:
		rotation -= TAU
	
	while rotation < -PI:
		rotation += TAU




func set_ring(new_ring:int):
	ring = new_ring
	radius = RingMap.get_radius_minimum(ring)
	recalcuate()

func set_segment(new_segment:int):
	rotation = float(new_segment) / RingMap.get_number_of_segments(ring)
	
	recalcuate()

func set_radius (new_radius:float):
	radius = new_radius
	
	recalcuate()

func set_rotation(new_rotation:float):
	rotation = new_rotation
	modulo_ring_vector()
	recalcuate()



func get_ring() -> int:
	return ring

func get_segment() -> int:
	return segment

func get_radius() -> float:
	return radius

func get_rotation() -> float:
	return rotation



func _to_string() -> String:
	return "(ring: %d, segment: %d, radius: %0.2f, rotation: %0.2f)" % [ring, segment, radius, rotation]
