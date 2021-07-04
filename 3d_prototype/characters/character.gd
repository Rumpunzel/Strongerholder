class_name Character
extends KinematicBody
tool

signal instantiated

export(Resource) var movement_stats

var velocity: Vector3
var is_grounded: bool

var _ground_check: RayCast



func _ready() -> void:
	if Engine.editor_hint:
		return
	
	_ground_check = $GroundCheck
	emit_signal("instantiated")


func _physics_process(_delta: float) -> void:
	if Engine.editor_hint:
		return
	
	#if not get_actions().moving_to_destination:
	velocity = move_and_slide(velocity)
	
	is_grounded = _ground_check.is_colliding()



func get_inputs() -> CharacterMovementInputs:
	assert($Controller/MovementInputs as CharacterMovementInputs)
	return $Controller/MovementInputs as CharacterMovementInputs

func get_actions() -> CharacterMovementActions:
	assert($Controller/MovementActions as CharacterMovementActions)
	return $Controller/MovementActions as CharacterMovementActions

func get_interaction_area() -> InteractionArea:
	assert($InteractionArea as InteractionArea)
	return $InteractionArea as InteractionArea

func get_navigation() -> Navigation:
	assert(get_parent() as Navigation)
	return get_parent() as Navigation



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
