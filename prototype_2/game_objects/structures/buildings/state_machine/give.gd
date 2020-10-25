class_name CityStructureStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends CityStructureState


const PERSIST_OBJ_PROPERTIES_3 := ["_item", "_receiver"]


var _item: GameResource = null
var _receiver: Node2D = null



func enter(parameters: Array = [ ]):
	if not parameters.empty():
		_item = parameters[0]
		_receiver = parameters[1]
	
	if _receiver:
		pilot_master.drop_item(_item, _receiver.global_position)
	else:
		pilot_master.drop_item(_item)
	
	if _receiver is Structure:
		_receiver.check_area_for_item(_item)
	
	_item = null
	_receiver = null
