class_name Character, "res://editor_tools/class_icons/spatials/icon_barbute.svg"
extends KinematicBody
tool

export(Resource) var movement_stats

var velocity: Vector3
var is_grounded: bool
var look_position: Vector3 = Vector3.ZERO

onready var _ground_check: RayCast = $GroundCheck


func _ready() -> void:
	set_axis_lock(PhysicsServer.BODY_AXIS_ANGULAR_Y, true)


func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	velocity = move_and_slide(velocity)
	is_grounded = _ground_check.is_colliding()
	
	if abs(look_position.x) > 0.1 or abs(look_position.z) > 0.1:
		_turn_to_look_postion(delta)


func save_to_var(save_file: File) -> void:
	save_file.store_var(transform)

func load_from_var(save_file: File) -> void:
	transform = save_file.get_var()


func get_navigation() -> Navigation:
	assert(get_parent() as Navigation)
	return get_parent() as Navigation


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
