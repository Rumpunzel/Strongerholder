class_name JobStateOperate, "res://class_icons/states/icon_state_operate.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES_3 := ["_structure_to_operate"]


var _structure_to_operate: CityStructure = null




func _ready() -> void:
	name = OPERATE




func check_for_exit_conditions(_employee: PuppetMaster, _employer: CityStructure, _dedicated_tool: Spyglass) -> void:
	if not _structure_to_operate.can_be_operated():
		exit(IDLE)




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		assert(parameters.size() == 1)
		
		_structure_to_operate = parameters[0]
		emit_signal("worker_assigned", _structure_to_operate)
	
	.enter([_structure_to_operate.global_position])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	emit_signal("worker_unassigned", _structure_to_operate)
	_structure_to_operate = null
	
	.exit(next_state, parameters)




func next_command(_employee: PuppetMaster, _dedicated_tool: Spyglass) -> InputMaster.Command:
	return InputMaster.InteractCommand.new(_structure_to_operate)


func current_target() -> GameObject:
	return _structure_to_operate
