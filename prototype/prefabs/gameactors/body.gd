extends KinematicBody



onready var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var ring_vector:RingVector setget set_ring_vector, get_ring_vector

var move_direction:Vector3 = Vector3() setget set_move_direction, get_move_direction

var fall_speed:float = 0.0
var jump_speed:float = 15.0
var jump_mod:float = 0.0

var grounded:bool = false
var can_jump:bool = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	look_at(Vector3(0, transform.origin.y, 0), Vector3.UP)
	
	var dir:Vector3 = transform.basis.x * move_direction.z + transform.basis.z * move_direction.x
	
	if can_jump:
		jump_mod = max(move_direction.y, jump_mod - delta * 5)
	
	fall_speed += default_gravity * delta * 0.5
	
	dir += transform.basis.y * (jump_speed * jump_mod - fall_speed)
	
	move_and_slide(dir, Vector3.UP, true)
	
	grounded = is_on_floor()
	
	if grounded:
		fall_speed = 0.0
		jump_mod = 0.0
		can_jump = move_direction.y <= 0



func set_ring_vector(new_vector:RingVector):
	if ring_vector:
		ring_vector.set_equal_to(new_vector)
	else:
		ring_vector = new_vector
	
	global_transform.origin = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius).rotated(Vector3.UP, ring_vector.rotation)


func set_move_direction(new_dirction:Vector3):
	move_direction = new_dirction



func get_ring_vector() -> RingVector:
	var rad = global_transform.origin.distance_to(Vector3())
	var rot = Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2.DOWN)
	
	if not ring_vector:
		ring_vector = RingVector.new(rad, rot)
	else:
		ring_vector.radius = rad
		ring_vector.rotation = rot
	
	return ring_vector


func get_move_direction() -> Vector3:
	return move_direction
