class_name Character, "res://editor_tools/class_icons/spatials/icon_barbute.svg"
extends KinematicBody
tool

export(Resource) var movement_stats

# INPUTS
# Vector3 position to move to
var destination_input := translation
# Vector3 direciton to move along
var movement_input := Vector3.ZERO
# Input triggers
var sprint_input := false
var jump_input := false

# ACTIONS
var horizontal_movement_vector := Vector2.ZERO setget _set_horizontal_movement_vector
var vertical_velocity := 0.0
var moving_to_destination := false
var target_speed := 1.0

var velocity := Vector3.ZERO setget set_velocity
var is_grounded := false
var look_position := Vector3.ZERO

var _avoid_obstacles: bool

onready var _ground_check: RayCast = $GroundCheck
onready var _navigation_agent: NavigationAgent = $NavigationAgent


func _ready() -> void:
	if Engine.editor_hint:
		return
	
	set_axis_lock(PhysicsServer.BODY_AXIS_ANGULAR_Y, true)
	destination_input = translation
	
	if _navigation_agent.avoidance_enabled and movement_stats.avoid_obstacles:
		_avoid_obstacles = true
		# warning-ignore:return_value_discarded
		_navigation_agent.connect("velocity_computed", self, "set_velocity")
	else:
		_avoid_obstacles = false


func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	velocity = move_and_slide(velocity)
	is_grounded = _ground_check.is_colliding()
	
	if abs(look_position.x) > 0.1 or abs(look_position.z) > 0.1:
		_turn_to_look_postion(delta)


func horizontal_move_action(is_aerial_movement := false) -> void:
	if moving_to_destination:
		_navigation_agent.set_target_location(destination_input)
	else:
		var move_speed: float = target_speed * movement_stats.move_speed
		if is_aerial_movement:
			move_speed *= movement_stats.aerial_modifier
		
		horizontal_movement_vector.x = movement_input.x * move_speed
		horizontal_movement_vector.y = movement_input.z * move_speed

func apply_movement_vector() -> Vector3:
	var horizontal_movement: Vector2
	
	if moving_to_destination:
		if not _navigation_agent.is_navigation_finished():
			var destination := _navigation_agent.get_next_location()
			var direction := destination - translation
			direction.y = translation.y
			direction = direction.normalized()
			
			horizontal_movement = Vector2(direction.x, direction.z) * movement_stats.move_speed
		else:
			horizontal_movement = Vector2.ZERO
	else:
		horizontal_movement = horizontal_movement_vector
	
	var new_movement_vector := Vector3(
		horizontal_movement.x,
		-vertical_velocity,
		horizontal_movement.y
	)
	
	if _avoid_obstacles and moving_to_destination:
		_navigation_agent.set_velocity(new_movement_vector)
	else:
		velocity = new_movement_vector
	
	if horizontal_movement != Vector2.ZERO:
		look_position = new_movement_vector * 100.0 + translation
	
	return velocity

func null_movement() -> void:
	destination_input = translation
	horizontal_movement_vector = Vector2.ZERO
	
	var new_movement_vector := Vector3.DOWN * vertical_velocity
	velocity = new_movement_vector


func save_to_var(save_file: File) -> void:
	save_file.store_var(transform)

func load_from_var(save_file: File) -> void:
	transform = save_file.get_var()


func set_velocity(new_velocity: Vector3) -> void:
	velocity = new_velocity

func _set_horizontal_movement_vector(new_vector: Vector2) -> void:
	horizontal_movement_vector = new_vector
	if horizontal_movement_vector != Vector2.ZERO:
		moving_to_destination = false


func get_target_desired_distance() -> float:
	return _navigation_agent.target_desired_distance

func get_navigation() -> WorldScene:
	assert(get_parent() as WorldScene)
	return get_parent() as WorldScene


func _turn_to_look_postion(delta: float) -> void:
	look_position.y = translation.y
	var new_transform := transform.looking_at(look_position, Vector3.UP)
	new_transform.basis = new_transform.basis.rotated(Vector3.UP, PI)
	transform = transform.interpolate_with(new_transform, movement_stats.turn_rate * delta)
	look_position = Vector3.ZERO


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not movement_stats:
		warning = "MovementStats are required"
	elif not movement_stats is CharacterMovementStatsResource:
		warning = "MovementStats are of the wrong type"
	
	return warning
