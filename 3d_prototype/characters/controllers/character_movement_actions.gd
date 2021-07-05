class_name CharacterMovementActions
extends Node

# warning-ignore-all:unused_class_variable
var horizontal_movement_vector: Vector2
var vertical_velocity: float

var destination_point: Vector3
var path: Array = [ ] setget _set_path

var moving_to_destination: bool
var target_speed: float

var _path_node: int = 0


func _process(_delta: float) -> void:
	if true or moving_to_destination:
		_calculate_target_speed(1.0)
	else:
		pass#_calculate_target_speed(input_vector.length())


func on_path() -> bool:
	return _path_node < path.size()

func next_path_point() -> Vector3:
	return path[_path_node]

func reached_point() -> void:
	_path_node += 1


func _calculate_target_speed(new_target_speed: float) -> void:
	target_speed = clamp(new_target_speed, 0.0, 1.0) * 1.0#(1.0 if is_running else _movement_stats.walking_modifier)


func _set_path(new_path: Array) -> void:
	path = new_path
	_path_node = 0
	$Line.draw_path(path)
