class_name CharacterMovementInputs
extends Node

# warning-ignore-all:unused_class_variable
var destination_input: Vector3
var input_vector: Vector2
var movement_input: Vector3

var getting_point_from_mouse: bool = false

var is_running: bool
var jump_input: bool
var attack_input: bool

var _navigation: Navigation
var _movement_stats: CharacterMovementStatsResource


func _ready() -> void:
	var character = owner
	_navigation = character.get_navigation()
	_movement_stats = character.movement_stats


func _process(_delta: float) -> void:
	if getting_point_from_mouse:
		_get_point_from_mouse()
	else:
		_recalculate_movement()


func _get_point_from_mouse() -> void:
	movement_input = Vector3.ZERO
	destination_input = CameraSystem.mouse_as_world_point(_navigation)

func _recalculate_movement() -> void:
	movement_input = CameraSystem.get_adjusted_movement(input_vector).normalized()# * target_speed
