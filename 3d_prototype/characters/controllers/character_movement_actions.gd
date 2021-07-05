class_name CharacterMovementActions
extends Node

# warning-ignore-all:unused_class_variable
var horizontal_movement_vector: Vector2 setget _set_horizontal_movement_vector
var vertical_velocity: float

var destination_point: Vector3 setget _set_destination_point
var path: Array = [ ] setget _set_path

var target_speed: float

var _navigation: Navigation
var _moving_to_destination: bool
var _path_node: int = 0


func _ready() -> void:
	_navigation = owner.get_navigation()

#func _process(_delta: float) -> void:
#	if true or moving_to_destination:
#		_calculate_target_speed(1.0)
#	else:
#		pass#_calculate_target_speed(input_vector.length())


func on_path() -> bool:
	return _path_node < path.size()

func next_path_point() -> Vector3:
	return path[_path_node]

func reached_point() -> void:
	_path_node += 1


#func _calculate_target_speed(new_target_speed: float) -> void:
#	target_speed = clamp(new_target_speed, 0.0, 1.0) * 1.0#(1.0 if is_running else _movement_stats.walking_modifier)


func _set_horizontal_movement_vector(new_vector: Vector2) -> void:
	horizontal_movement_vector = new_vector
	_set_path([ ])

func _set_destination_point(new_point: Vector3) -> void:
	destination_point = new_point
	assert(false)
	_set_path(_navigation.get_simple_path(owner.translation, destination_point))

func _set_path(new_path: Array) -> void:
	path = new_path
	_path_node = 1
	_moving_to_destination = path.size() > 1
	$Line.draw_path(path)
	$MovementDingle.visible = path.size() > 1
