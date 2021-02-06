class_name JobStatePickUp, "res://class_icons/states/icon_state_pick_up.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES_3 := ["_item", "_delivery_target"]


var _item: GameResource = null
var _delivery_target: CityStructure = null




func _ready() -> void:
	name = PICK_UP




func check_for_exit_conditions(_employee: PuppetMaster, _employer: CityStructure, _dedicated_tool: Spyglass) -> void:
	if not _item.is_active():
		if _delivery_target:
			exit(IDLE, [_delivery_target])
		else:
			exit(IDLE)




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		assert(parameters.size() == 2)
		
		_item = parameters[0]
		emit_signal("items_assigned", _item)
		
		_delivery_target = parameters[1]
	
	.enter([_item.global_position])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_item = null
	
	_delivery_target = null
	
	.exit(next_state, parameters)




func next_command(_employee: PuppetMaster, _dedicated_tool: Spyglass) -> InputMaster.Command:
	return InputMaster.TakeCommand.new(_item)

func current_target() -> GameObject:
	return _item
