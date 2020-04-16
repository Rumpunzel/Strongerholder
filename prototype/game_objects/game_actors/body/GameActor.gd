class_name GameActor, "res://assets/icons/game_actors/icon_game_actor.svg"
extends KinematicBody


signal moved(direction)
signal entered_segment(ring_vector)
signal activate
signal died


export(NodePath) var _hit_box_node
export(NodePath) var _puppet_master_node
export(NodePath) var _animation_tree_node

export var move_speed: float = 4.0 setget , get_move_speed
export var sprint_modifier: float = 2.0 setget , get_sprint_modifier
export var jump_speed: float = 20.0 setget , get_jump_speed


var ring_vector: RingVector = RingVector.new(0, 0) setget set_ring_vector, get_ring_vector
var type: int setget set_actor_type, get_actor_type

var velocity: Vector3 = Vector3() setget set_velocity, get_velocity
var sprinting: bool = false setget set_sprinting, get_sprinting


# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var _movement_modifier: float = 1.0
var _fall_speed: float = 0.0
var _jump_mod: float = 0.0

var _grounded: bool = false
var _can_jump: bool = true


onready var _default_gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var _cliff_dection: CliffDetection = CliffDetection.new(self)

onready var _hit_box: ActorHitBox = get_node(_hit_box_node)
onready var _puppet_master = get_node(_puppet_master_node)
onready var _animation_tree: AnimationStateMachine = get_node(_animation_tree_node)




# Called when the node enters the scene tree for the first time.
func _ready():
	ring_vector.connect("vector_changed", self, "_updated_ring_vector")

func _setup(new_ring_vector: RingVector, actor_type: int):
	set_ring_vector(new_ring_vector)
	set_actor_type(actor_type)
	activate_actor()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation.y = atan2(transform.origin.x, transform.origin.z)
	
	var dir: Vector3 = transform.basis.x * velocity.z + transform.basis.z * velocity.x
	
	_can_jump = _can_jump and velocity.y > 0
	
	if _can_jump:
		_jump_mod = min(1.0, _jump_mod + velocity.y * delta * 10)
	else:
		_jump_mod -= delta * 2
	
	_fall_speed += _default_gravity * delta
	
	dir += transform.basis.y * (jump_speed * _jump_mod - _fall_speed)
	
	var new_velocity = move_and_slide(dir, Vector3.UP, true)
	
	_grounded = is_on_floor()
	
	if _grounded:
		_fall_speed = 0.0
		_jump_mod = 0.0
		_can_jump = velocity.y <= 0
	
	velocity = new_velocity
	
	emit_signal("moved", velocity)




func activate_actor():
	emit_signal("activate")


func move_to(direction: Vector3, is_sprinting: bool = false) -> RingVector:
	set_sprinting(is_sprinting)
	set_velocity(direction)
	_parse_state(direction)
	
	return get_ring_vector()


func object_died():
	emit_signal("died")





func _parse_state(direction: Vector3):
	var camera = get_viewport().get_camera()
	var angle = -Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2(camera.global_transform.origin.x, camera.global_transform.origin.z)) if camera else 0.0
	var movement_vector: Vector2 = Vector2(direction.z, direction. x) if direction.length() > 0 else _animation_tree.blend_positions
	movement_vector = movement_vector.rotated(angle)
	
	if direction.length() > 0:
		_animation_tree.blend_positions = movement_vector
		_animation_tree.travel("run", false)
	elif _animation_tree.get_current_state() == "run":
		_animation_tree.travel("idle", false)


func _updated_ring_vector():
	emit_signal("entered_segment", ring_vector)





func set_ring_vector(new_vector: RingVector):
	if ring_vector:
		ring_vector.set_equal_to(new_vector)
	else:
		ring_vector = new_vector
	
	global_transform.origin = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius).rotated(Vector3.UP, ring_vector.rotation)


func set_velocity(new_velocity: Vector3):
	velocity = _cliff_dection.limit_movement(new_velocity)
	velocity.y = 0
	velocity = velocity.normalized() * move_speed * _movement_modifier
	velocity.y = new_velocity.y


func set_sprinting(new_status: bool):
	sprinting = new_status
	_movement_modifier = sprint_modifier if sprinting else 1.0


func set_actor_type(actor_type: int):
	_hit_box.type = actor_type
	_puppet_master.set_actor_type(actor_type)
	name = str(Constants.enum_name(Constants.Actors, actor_type))
	type = actor_type




func get_ring_vector() -> RingVector:
	var rad = global_transform.origin.distance_to(Vector3())
	var rot = Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2.DOWN)
	
	if not ring_vector:
		ring_vector = RingVector.new(rad, rot)
	else:
		ring_vector.radius = rad
		ring_vector.rotation = rot
	
	return ring_vector


func get_actor_type() -> int:
	return _hit_box.type

func get_move_speed() -> float:
	return move_speed

func get_sprint_modifier() -> float:
	return sprint_modifier

func get_jump_speed() -> float:
	return jump_speed

func get_velocity() -> Vector3:
	return velocity

func get_sprinting() -> bool:
	return sprinting
