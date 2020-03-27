extends Resource
class_name RingVector


var ring:int setget set_ring, get_ring
var segment:int setget set_segment, get_segment

var radius:float setget set_radius, get_radius
var rotation:float setget set_rotation, get_rotation


signal vector_changed



func _init(new_x, new_y, use_as_int_values:bool = false):
	if use_as_int_values:
		ring = int(new_x)
		segment = int(new_y)
	else:
		radius = float(new_x)
		rotation = float(new_y)
	
	recalcuate(use_as_int_values)


func _ready():
	emit_signal("vector_changed")



func recalcuate(has_int_values:bool = false):
	if has_int_values:
		var new_radius = CityLayout.get_radius_minimum(ring)
		var new_rotation = (float(segment) / CityLayout.get_number_of_segments(ring)) * TAU
		
		if not new_radius == radius or not new_rotation == rotation:
			radius = new_radius
			rotation = new_rotation
			
			emit_signal("vector_changed")
	else:
		var new_ring = CityLayout.get_current_ring(radius)
		var new_segment = CityLayout.get_current_segment(new_ring, rotation)
		
		if not new_ring == ring or not new_segment == segment:
			ring = new_ring
			segment = new_segment
		
			emit_signal("vector_changed")


func set_equal_to(new_vector:RingVector):
	var changed = not (ring == new_vector.ring and segment == new_vector.segment)
	
	ring = new_vector.ring
	segment = new_vector.segment
	
	radius = new_vector.radius
	rotation = new_vector.rotation
	
	if changed:
		emit_signal("vector_changed")


func modulo_ring_vector():
	while rotation > PI:
		rotation -= TAU
	
	while rotation < -PI:
		rotation += TAU




func set_ring(new_ring:int):
	ring = new_ring
	recalcuate(true)

func set_segment(new_segment:int):
	segment = new_segment
	recalcuate(true)

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
