class_name JobStatePickUp, "res://class_icons/states/icon_state_pick_up.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES_3 := ["_item", "_delivery_target"]


var _item: GameResource = null
var _delivery_target: PilotMaster = null




func _ready() -> void:
	name = PICK_UP




func _check_for_exit_conditions() -> void:
	if not _item.is_active():
		if _delivery_target:
			exit(IDLE, [_delivery_target])
		else:
			exit(IDLE)




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		assert(parameters.size() == 2)
		
		_item = parameters[0]
		_item.assign_worker(employee)
		
		_delivery_target = parameters[1]
	
	.enter([_item.global_position])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_item = null
	
	_delivery_target = null
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	return InputMaster.TakeCommand.new(_item)

func current_target() -> Node2D:
	return _item
