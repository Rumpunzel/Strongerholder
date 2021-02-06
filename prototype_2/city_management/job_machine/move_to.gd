class_name JobStateMoveTo, "res://class_icons/states/icon_state_move_to.svg"
extends JobState


const PERSIST_OBJ_PROPERTIES_2 := ["_pathing_target", "_path", "_calculated"]


var _pathing_target: Vector2 = Vector2()
var _path: PoolVector2Array = [ ]
var _calculated := false


onready var _navigator: Navigator = ServiceLocator.navigator




func _ready() -> void:
	name = MOVE_TO




func check_for_exit_conditions(_employee: PuppetMaster, _employer: CityStructure, _dedicated_tool: Spyglass) -> void:
	if _path.empty():
		exit(IDLE)




func enter(parameters: Array = [ ]) -> void:
	_pathing_target = parameters[0]
	
	.enter(parameters)


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_pathing_target = Vector2()
	_path = [ ]
	_calculated = false
	
	.exit(next_state, parameters)




func next_step(start_position: Vector2) -> Vector2:
	if not _calculated:
		_calculate_path(start_position, _pathing_target)
	
	while not _path.empty() and start_position.distance_to(_path[0]) <= 1.0:
		_path.remove(0)
	
	var movement_vector: Vector2 = Vector2()
	
	if not _path.empty():
		movement_vector = _path[0] - start_position
	
	return movement_vector



func _calculate_path(start: Vector2, end: Vector2) -> void:
	_calculated = true
	_path = _navigator.get_simple_path(start, end)
