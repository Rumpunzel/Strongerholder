class_name GameCharacter
extends KinematicBody


signal moved(direction)


export(NodePath) var animation_tree_node


var ring_vector: RingVector setget set_ring_vector, get_ring_vector

var velocity: Vector3 = Vector3() setget set_velocity, get_velocity
var sprinting: bool = false setget set_sprinting, get_sprinting


var move_speed: float = 4.0
var sprint_modifier: float = 2.0
var jump_speed: float = 20.0

# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var movement_modifier: float = 1.0
var fall_speed: float = 0.0
var jump_mod: float = 0.0

var grounded: bool = false
var can_jump: bool = true


onready var default_gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var cliff_dection: CliffDetection = CliffDetection.new(self)
onready var area: ActorArea = $area setget , get_area
onready var animation_tree: AnimationStateMachine = get_node(animation_tree_node)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation.y = atan2(transform.origin.x, transform.origin.z)
	
	var dir: Vector3 = transform.basis.x * velocity.z + transform.basis.z * velocity.x
	
	can_jump = can_jump and velocity.y > 0
	
	if can_jump:
		jump_mod = min(1.0, jump_mod + velocity.y * delta * 10)
	else:
		jump_mod -= delta * 2
	
	fall_speed += default_gravity * delta
	
	dir += transform.basis.y * (jump_speed * jump_mod - fall_speed)
	
	var new_velocity = move_and_slide(dir, Vector3.UP, true)
	
	grounded = is_on_floor()
	
	if grounded:
		fall_speed = 0.0
		jump_mod = 0.0
		can_jump = velocity.y <= 0
	
	velocity = new_velocity
	
	emit_signal("moved", velocity)




func move_to(direction: Vector3, is_sprinting: bool = false) -> RingVector:
	set_sprinting(is_sprinting)
	set_velocity(direction)
	parse_state(direction)
	
	return get_ring_vector()


func parse_state(direction: Vector3):
	var camera = get_viewport().get_camera()
	var angle = -Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2(camera.global_transform.origin.x, camera.global_transform.origin.z)) if camera else 0.0
	var movement_vector: Vector2 = Vector2(direction.z, direction. x) if direction.length() > 0 else animation_tree.blend_positions
	movement_vector = movement_vector.rotated(angle)
	
	
	if direction.length() > 0:
		animation_tree.blend_positions = movement_vector
		animation_tree.travel("run")
	elif animation_tree.get_current_state() == "run":
		animation_tree.travel("idle")


func animate(animation: String, stop_movement: bool = true):
	if animation_tree.is_idle_animation():
		if stop_movement:
			move_to(Vector3())
		
		animation_tree.travel(animation)


func is_idle() -> bool:
	return animation_tree.is_idle()


func is_in_range(object_of_interest) -> bool:
	return area.has_object(object_of_interest)



func set_ring_vector(new_vector: RingVector):
	if ring_vector:
		ring_vector.set_equal_to(new_vector)
	else:
		ring_vector = new_vector
	
	global_transform.origin = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius).rotated(Vector3.UP, ring_vector.rotation)


func set_velocity(new_velocity: Vector3):
	velocity = cliff_dection.limit_movement(new_velocity)
	velocity.y = 0
	velocity = velocity.normalized() * move_speed * movement_modifier
	velocity.y = new_velocity.y


func set_sprinting(new_status: bool):
	sprinting = new_status
	movement_modifier = sprint_modifier if sprinting else 1.0



func get_ring_vector() -> RingVector:
	var rad = global_transform.origin.distance_to(Vector3())
	var rot = Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2.DOWN)
	
	if not ring_vector:
		ring_vector = RingVector.new(rad, rot)
	else:
		ring_vector.radius = rad
		ring_vector.rotation = rot
	
	return ring_vector


func get_area() -> ActorArea:
	return area

func get_velocity() -> Vector3:
	return velocity

func get_sprinting() -> bool:
	return sprinting
