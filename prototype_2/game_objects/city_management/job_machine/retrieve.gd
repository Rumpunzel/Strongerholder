class_name JobStateRetrieve, "res://assets/icons/game_actors/states/icon_state_retrieve.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES_3 := ["_item_type", "_structure_to_retrieve_from", "_delivery_target", "_requested_item"]


var _item_type = null
var _structure_to_retrieve_from: CityStructure = null
var _delivery_target: PilotMaster = null

var _requested_item: bool = false




func _ready():
	name = RETRIEVE




func _check_for_exit_conditions():
	if _requested_item:
		yield(get_tree(), "idle_frame")
		
		var nearest_item: GameResource = _get_nearest_item_of_type(_item_type)
		
		if nearest_item:
			if not dedicated_tool and nearest_item is Spyglass:
				get_parent().dedicated_tool = nearest_item
			
			exit(PICK_UP, [nearest_item, _delivery_target])
		elif _structure_to_retrieve_from._pilot_master.how_many_of_item(_item_type) == 0:
			exit(IDLE, [_delivery_target])




func enter(parameters: Array = [ ]):
	if not parameters.empty():
		assert(parameters.size() == 3)
		
		_item_type = parameters[0]
		
		_structure_to_retrieve_from = parameters[1]
		_structure_to_retrieve_from.assign_gatherer(employee, _item_type)
		
		_delivery_target = parameters[2]
	
	.enter([_structure_to_retrieve_from.global_position])


func exit(next_state: String, parameters: Array = [ ]):
	if _structure_to_retrieve_from:
		_structure_to_retrieve_from.unassign_gatherer(employee, _item_type)
		_structure_to_retrieve_from = null
	
	_item_type = null
	_delivery_target = null
	
	_requested_item = false
	
	.exit(next_state, parameters)




func next_command() -> InputMaster.Command:
	_requested_item = true
	
	return InputMaster.RequestCommand.new(_item_type, _structure_to_retrieve_from)


func current_target() -> Node2D:
	return _structure_to_retrieve_from
