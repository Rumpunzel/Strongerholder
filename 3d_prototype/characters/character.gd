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
var attack_input := false

# ACTIONS
var horizontal_movement_vector := Vector2.ZERO setget _set_horizontal_movement_vector
var vertical_velocity := 0
var moving_to_destination := false
var target_speed := 1.0


var velocity := Vector3.ZERO setget set_velocity
var is_grounded := false
var look_position := Vector3.ZERO

onready var _ground_check: RayCast = $GroundCheck


func _ready() -> void:
	set_axis_lock(PhysicsServer.BODY_AXIS_ANGULAR_Y, true)
	destination_input = translation


func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	velocity = move_and_slide(velocity)
	is_grounded = _ground_check.is_colliding()
	
	if abs(look_position.x) > 0.1 or abs(look_position.z) > 0.1:
		_turn_to_look_postion(delta)

func _process(_delta: float) -> void:
	_debug_path()


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


func get_navigation() -> WorldScene:
	assert(get_parent() as WorldScene)
	return get_parent() as WorldScene

func get_navigation_agent() -> NavigationAgent:
	return $NavigationAgent as NavigationAgent


func _turn_to_look_postion(delta: float) -> void:
	look_position.y = translation.y
	var new_transform := transform.looking_at(look_position, Vector3.UP)
	new_transform.basis = new_transform.basis.rotated(Vector3.UP, PI)
	transform = transform.interpolate_with(new_transform, movement_stats.turn_rate * delta)
	look_position = Vector3.ZERO

func _debug_path() -> void:
	# warning-ignore:unsafe_method_access
	var _navigation_agent: NavigationAgent = get_navigation_agent()
	# warning-ignore:unsafe_method_access
	$Debug/Line.draw_path(_navigation_agent.get_nav_path())
	# warning-ignore:unsafe_property_access
	$Debug/Line.visible = moving_to_destination
	# warning-ignore:unsafe_property_access
	$Debug/MovementDingle.translation = _navigation_agent.get_target_location()
	# warning-ignore:unsafe_property_access
	$Debug/MovementDingle.visible = moving_to_destination


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not movement_stats:
		warning = "MovementStats are required"
	elif not movement_stats is CharacterMovementStatsResource:
		warning = "MovementStats are of the wrong type"
	
	return warning
