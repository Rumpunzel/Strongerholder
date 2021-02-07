class_name JobStateRetrieve, "res://class_icons/states/icon_state_retrieve.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES := [ "_item_type", "_structure_to_retrieve_from", "_delivery_target" ]
const PERSIST_PROPERTIES_3 := [ "_requested_item" ]


var _item_type = null
var _structure_to_retrieve_from: CityStructure = null
var _delivery_target: CityStructure = null

var _requested_item: bool = false




func _ready() -> void:
	name = RETRIEVE




func check_for_exit_conditions(employee: PuppetMaster, _employer: CityStructure, _dedicated_tool: Spyglass) -> void:
	if not employee.has_inventory_space_for(GameClasses.get_script_constant_map()[_item_type]) or _structure_to_retrieve_from.has_how_many_of_item(_item_type).empty():
		exit(IDLE, [_delivery_target])




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		assert(parameters.size() == 3)
		
		_item_type = parameters[0]
		
		_structure_to_retrieve_from = parameters[1]
		emit_signal("gatherer_assigned", _structure_to_retrieve_from, _item_type)
		
		_delivery_target = parameters[2]
	
	.enter([_structure_to_retrieve_from.global_position])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	if _structure_to_retrieve_from:
		emit_signal("gatherer_unassigned", _structure_to_retrieve_from, _item_type)
		_structure_to_retrieve_from = null
	
	_item_type = null
	_delivery_target = null
	
	_requested_item = false
	
	.exit(next_state, parameters)




func next_command(_employee: PuppetMaster, _dedicated_tool: Spyglass) -> InputMaster.Command:
	_requested_item = true
	
	return InputMaster.RequestCommand.new(_item_type, _structure_to_retrieve_from)


func current_target() -> GameObject:
	return _structure_to_retrieve_from
