class_name GameObject, "res://assets/icons/icon_game_object.svg"
extends StaticBody


signal activate
signal deactivate
signal died


var ring_vector: RingVector = RingVector.new(0, 0) setget set_ring_vector, get_ring_vector
var active: bool setget set_active, is_active
var type setget set_type, get_type




func _ready():
	pass

func _setup(new_ring_vector: RingVector):
	set_ring_vector(new_ring_vector)
	activate_object()




func activate_object():
	emit_signal("activate")

func deactivate_object():
	emit_signal("deactivate")

func object_died():
	emit_signal("died")




func set_ring_vector(new_vector: RingVector):
	if ring_vector:
		ring_vector.set_equal_to(new_vector)
	else:
		ring_vector = new_vector
	
	var new_position: Vector3 = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius).rotated(Vector3.UP, ring_vector.rotation)
	global_transform.origin = new_position
	rotation.y = atan2(transform.origin.x, transform.origin.z)

func set_active(new_status: bool):
	$hit_box.active = new_status
	active = new_status

func set_type(new_type):
	$hit_box.type = new_type
	type = new_type



func get_ring_vector() -> RingVector:
	var rad = global_transform.origin.distance_to(Vector3())
	var rot = Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2.DOWN)
	
	if not ring_vector:
		ring_vector = RingVector.new(rad, rot)
	else:
		ring_vector.radius = rad
		ring_vector.rotation = rot
	
	return ring_vector

func is_active() -> bool:
	active = $hit_box.active
	return active

func get_type():
	return $hit_box.type
