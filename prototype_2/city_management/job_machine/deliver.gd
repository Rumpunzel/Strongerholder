class_name JobStateDeliver, "res://class_icons/game_actors/states/icon_state_deliver.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES_3 := ["_delivery_target", "_target_structure"]


var _delivery_target: PilotMaster = null
var _target_structure: Structure = null




func _ready() -> void:
	name = DELIVER




func _check_for_exit_conditions() -> void:
	if _job_items().empty():
		exit(IDLE)




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		assert(parameters.size() == 1 and parameters[0])
		
		_delivery_target = parameters[0]
		_target_structure = _delivery_target.game_object
	
	.enter([_delivery_target.global_position])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_delivery_target = null
	_target_structure = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	if not _job_items().empty():
		var item: GameResource = _job_items().front()
		
		item.unassign_worker(employee)
		
		return InputMaster.GiveCommand.new(item, _delivery_target)
	
	return InputMaster.Command.new()


func current_target() -> Node2D:
	return _target_structure
