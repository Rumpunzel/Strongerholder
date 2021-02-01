class_name JobStateOperate, "res://class_icons/game_actors/states/icon_state_operate.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES_3 := ["_structure_to_operate"]


var _structure_to_operate: CityStructure = null




func _ready() -> void:
	name = OPERATE




func _check_for_exit_conditions() -> void:
	if not _structure_to_operate.can_be_operated():
		exit(IDLE)




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		assert(parameters.size() == 1)
		
		_structure_to_operate = parameters[0]
		_structure_to_operate.assign_worker(employee)
	
	.enter([_structure_to_operate.global_position])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_structure_to_operate.unassign_worker(employee)
	_structure_to_operate = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.InteractCommand.new(_structure_to_operate)


func current_target() -> Node2D:
	return _structure_to_operate
