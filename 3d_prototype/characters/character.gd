class_name Character
extends KinematicBody
tool

signal instantiated


# warning-ignore-all:unused_class_variable
export(Resource) var movement_stats = null


var velocity: Vector3

var input_vector: Vector2

var movement_input: Vector3
var horizontal_movement_vector: Vector2
var vertical_velocity: float

var destination_input: Vector3
var destination_point: Vector3
var path: Array = [ ]

var moving_to_destination: bool

var is_grounded: bool

var is_running: bool
var target_speed: float

var jump_input: bool
var attack_input: bool

var navigation: Navigation


var _getting_point_from_mouse: bool = false
var _ground_check: RayCast



func _enter_tree() -> void:
	navigation = get_parent() as Navigation
	_ground_check = $GroundCheck


func _ready() -> void:
	if Engine.editor_hint:
		return
	
	emit_signal("instantiated")


func _process(_delta: float) -> void:
	if Engine.editor_hint:
		return
	
	_read_inputs()
	
	if moving_to_destination:
		_calculate_target_speed(1.0)
	else:
		_calculate_target_speed(input_vector.length())
		destination_input = translation
	
	if _getting_point_from_mouse:
		_get_point_from_mouse()
	else:
		_recalculate_movement()


func _physics_process(_delta: float) -> void:
	if Engine.editor_hint:
		return
	
	if moving_to_destination:
		if path.empty():
			return
		
		var destination: Vector3 = path[0]
		var direction := destination - translation
		var direction_length := direction.length()
		var step_size: float = movement_stats.move_speed
		
		#if step_size * delta > direction_length:
		#	step_size = direction_length / delta
		#	path.remove(0)
		print(path)
		velocity = move_and_slide(direction.normalized() * step_size)
	else:
		velocity = move_and_slide(velocity)
	
	is_grounded = _ground_check.is_colliding()



func _read_inputs() -> void:
	input_vector = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	if Input.is_action_just_pressed("sprint"):
		is_running = true
	if Input.is_action_just_released("sprint"):
		is_running = false
	
	if Input.is_action_just_pressed("jump"):
		jump_input = true
	if Input.is_action_just_released("jump"):
		jump_input = false
	
	if Input.is_action_just_pressed("mouse_movement"):
		_getting_point_from_mouse = true
	if Input.is_action_just_released("mouse_movement"):
		_getting_point_from_mouse = false


func _recalculate_movement() -> void:
	movement_input = CameraSystem.get_adjusted_movement(input_vector).normalized() * target_speed


func _get_point_from_mouse() -> void:
	movement_input = Vector3.ZERO
	destination_input = CameraSystem.mouse_as_world_point(navigation)


func _calculate_target_speed(new_target_speed: float) -> void:
	new_target_speed = clamp(new_target_speed, 0.0, 1.0) * (1.0 if is_running else movement_stats.walking_modifier)
	target_speed = new_target_speed


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Structure
	warning = "Character has no visuals"
	for child in get_children():
		if child is GeometryInstance or child is CharacterModel:
			warning = ""
			break
	
	# Data
	if not movement_stats:
		warning = "MovementStats are required"
	elif not movement_stats is CharacterMovementStatsResource:
		warning = "MovementStats are of the wrong type"
	
	return warning
