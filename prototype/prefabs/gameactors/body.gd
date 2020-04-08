extends KinematicBody


signal moved(direction)


export(NodePath) var animation_tree_node


var ring_vector: RingVector setget set_ring_vector, get_ring_vector

var velocity: Vector3 = Vector3() setget set_velocity, get_velocity
var sprinting: bool = false setget set_sprinting, get_sprinting


var move_speed: float = 3.0
var sprint_modifier: float = 2.0
var jump_speed: float = 15.0

# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var movement_modifier: float = 1.0
var fall_speed: float = 0.0
var jump_mod: float = 0.0

var grounded: bool = false
var can_jump: bool = false


onready var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var cliff_dection = CliffDetection.new(self)
onready var animation_tree: AnimationTree = get_node(animation_tree_node)
onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
onready var camera = get_viewport().get_camera()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	look_at(Vector3(0, transform.origin.y, 0), Vector3.UP)
	
	var dir: Vector3 = transform.basis.x * velocity.z + transform.basis.z * velocity.x
	
	if can_jump:
		jump_mod = max(velocity.y, jump_mod - delta * 5)
	
	fall_speed += default_gravity * delta * 0.5
	
	dir += transform.basis.y * (jump_speed * jump_mod - fall_speed)
	
	velocity = move_and_slide(dir, Vector3.UP, true)
	
	grounded = is_on_floor()
	
	if grounded:
		fall_speed = 0.0
		jump_mod = 0.0
		can_jump = velocity.y <= 0
	
	emit_signal("moved", velocity)




func move_to(direction: Vector3, is_sprinting: bool) -> RingVector:
	set_sprinting(is_sprinting)
	set_velocity(direction)
	parse_state(direction)
	
	return get_ring_vector()


func parse_state(direction: Vector3):
	var angle = -Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2(camera.global_transform.origin.x, camera.global_transform.origin.z))
	var movement_vector: Vector2 = Vector2(direction.z, direction. x) if direction.length() > 0 else Vector2.DOWN
	movement_vector = movement_vector.rotated(angle)
	
	animation_tree.set("parameters/idle/blend_position", movement_vector)
	animation_tree.set("parameters/run/blend_position", movement_vector)
	animation_tree.set("parameters/attack/blend_position", movement_vector)
	animation_tree.set("parameters/give/blend_position", movement_vector)
	
	if direction.length() > 0:
		state_machine.travel("run")
	elif state_machine.get_current_node() == "run":
		state_machine.travel("idle")



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


func get_velocity() -> Vector3:
	return velocity


func get_sprinting() -> bool:
	return sprinting
