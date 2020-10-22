class_name JobStateRetrieve, "res://assets/icons/game_actors/states/icon_state_retrieve.svg"
extends JobStateMoveTo


var _item_type = null
var _structure_to_retrieve_from: CityStructure = null
var _delivery_target: PilotMaster = null

var _requested_item: bool = false




func _process(_delta: float):
	if _requested_item:
		var nearest_item: GameResource = _get_nearest_item_of_type(_item_type)
		
		if nearest_item:
			exit(PICK_UP, [nearest_item, _delivery_target])
#		else:
#			exit(IDLE)




func enter(parameters: Array = [ ]):
	_item_type = parameters[0]
	
	_structure_to_retrieve_from = parameters[1]
	_structure_to_retrieve_from.assign_gatherer(employee, _item_type)
	
	_delivery_target = parameters[2]
	
	.enter([_structure_to_retrieve_from.global_position])


func exit(next_state: String, parameters: Array = [ ]):
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
