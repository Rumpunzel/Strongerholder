class_name CityStructure
extends StaticBody


var ring_vector: RingVector = RingVector.new(0, 0) setget set_ring_vector, get_ring_vector



func _ready():
	pass

func _setup(new_ring_vector: RingVector):
	set_ring_vector(new_ring_vector)



func set_ring_vector(new_vector: RingVector):
	if ring_vector:
		ring_vector.set_equal_to(new_vector)
	else:
		ring_vector = new_vector
	
	global_transform.origin = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius).rotated(Vector3.UP, ring_vector.rotation)
	rotation.y = atan2(transform.origin.x, transform.origin.z)



func get_ring_vector() -> RingVector:
	var rad = global_transform.origin.distance_to(Vector3())
	var rot = Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2.DOWN)
	
	if not ring_vector:
		ring_vector = RingVector.new(rad, rot)
	else:
		ring_vector.radius = rad
		ring_vector.rotation = rot
	
	return ring_vector