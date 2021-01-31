class_name JobStateGather, "res://assets/icons/game_actors/states/icon_state_gather.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES_3 := ["_item_type", "_structure_to_gather_from", "_delivery_target"]


var _item_type = null
var _structure_to_gather_from: Structure = null
var _delivery_target: PilotMaster = null




func _ready() -> void:
	name = GATHER




func _check_for_exit_conditions() -> void:
	if not _structure_to_gather_from.is_active():
		var nearest_item: GameResource = _get_nearest_item_of_type(_item_type)
		
		if nearest_item:
			exit(PICK_UP, [nearest_item, _delivery_target])
		else:
			exit(IDLE, [_delivery_target])




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		assert(parameters.size() == 3)
		
		_item_type = parameters[0]
		
		_structure_to_gather_from = parameters[1]
		_structure_to_gather_from.assign_worker(employee)
		
		_delivery_target = parameters[2]
	
	.enter([_structure_to_gather_from.global_position])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_item_type = null
	
	_structure_to_gather_from.unassign_worker(employee)
	_structure_to_gather_from = null
	
	_delivery_target = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.AttackCommand.new(dedicated_tool)

func current_target() -> Node2D:
	return _structure_to_gather_from
