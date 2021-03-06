class_name RingVector
extends Resource

# This is a custom data type to store position data
#	a position is abstracted by 2 different parameters:
#	- the radius from the center
#	- the position on the circumference defined by the prior radius

# This signal is emiited when the discrete parts of the vector change
signal vector_changed

# There are 2 different types of these 2-dimensional vectors
#	- a discrete vector; here the ring is subdivided into segments
var ring: int setget set_ring
var segment: int setget set_segment

#	- a continous vector; here it describes the world distance from the center
#		the position on the circumference is an angle in radians from -PI to PI
var radius: float setget set_radius
var rotation: float setget set_rotation





func _init(new_x, new_y, use_as_int_values: bool = false):
	if use_as_int_values:
		ring = int(new_x)
		segment = int(new_y)
	else:
		radius = float(new_x)
		rotation = float(new_y)
	
	recalcuate(use_as_int_values)


func _ready():
	emit_signal("vector_changed")



func recalcuate(has_int_values: bool = false):
	if has_int_values:
		var new_radius = CityLayout.get_radius_minimum(ring)
		var new_rotation = (float(segment) / CityLayout.get_number_of_segments(ring)) * TAU
		
		modulo_ring_vector()
		
		if not new_radius == radius or not new_rotation == rotation:
			radius = new_radius
			rotation = new_rotation
			
			emit_signal("vector_changed")
	else:
		var new_ring = CityLayout.get_current_ring(radius)
		var new_segment = CityLayout.get_current_segment(new_ring, rotation)
		
		modulo_ring_vector()
		
		if not new_ring == ring or not new_segment == segment:
			ring = new_ring
			segment = new_segment
			
			emit_signal("vector_changed")


func equals(other: RingVector):
	return radius == other.radius and rotation == other.rotation


func set_equal_to(new_vector: RingVector):
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




func set_ring(new_ring: int):
	ring = new_ring
	recalcuate(true)

func set_segment(new_segment: int):
	segment = (new_segment + CityLayout.get_number_of_segments(ring)) % CityLayout.get_number_of_segments(ring)
	recalcuate(true)

func set_radius (new_radius: float):
	radius = new_radius
	recalcuate()

func set_rotation(new_rotation: float):
	rotation = new_rotation
	modulo_ring_vector()
	recalcuate()



func _to_string() -> String:
	return "(ring: %d, segment: %d, radius: %0.2f, rotation: %0.2f)" % [ring, segment, radius, rotation]
