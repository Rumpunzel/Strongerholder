class_name JobStateMoveTo, "res://class_icons/game_actors/states/icon_state_move_to.svg"
extends JobState


const PERSIST_OBJ_PROPERTIES_2 := ["_pathing_target", "_path"]


var _pathing_target: Vector2 = Vector2()
var _path: PoolVector2Array = [ ]




func _ready() -> void:
	name = MOVE_TO




func _check_for_exit_conditions() -> void:
	if _path.empty():
		exit(IDLE)




func enter(parameters: Array = [ ]) -> void:
	_pathing_target = parameters[0]
	
	_calculate_path(employee.global_position, _pathing_target)
	
	.enter(parameters)


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_pathing_target = Vector2()
	_path = [ ]
	
	.exit(next_state, parameters)




func next_step() -> Vector2:
	while not _path.empty() and employee.global_position.distance_to(_path[0]) <= 1.0:
		_path.remove(0)
	
	var movement_vector: Vector2 = Vector2()
	
	if not _path.empty():
		movement_vector = _path[0] - employee.global_position
	
	return movement_vector



func _calculate_path(start: Vector2, end: Vector2) -> void:
	_path = _navigator.get_simple_path(start, end)
