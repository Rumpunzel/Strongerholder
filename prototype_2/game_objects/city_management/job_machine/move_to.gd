class_name JobStateMoveTo, "res://assets/icons/game_actors/states/icon_state_move_to.svg"
extends JobState


var _pathing_target: Vector2 = Vector2()
var _path: PoolVector2Array = [ ]




#func _process(_delta: float):
#	if _path.empty():
#		exit(IDLE)




func enter(parameters: Array = [ ]):
	_pathing_target = parameters[0]
	
	_calculate_path(employee.global_position, _pathing_target)
	
	.enter(parameters)


func exit(next_state: String, parameters: Array = [ ]):
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



func _calculate_path(start: Vector2, end: Vector2):
	_path = _navigator.get_simple_path(start, end)
