class_name CityStructureStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends CityStructureState


export(NodePath) var _pilot_master_node


var _item: GameResource = null
var _receiver: Node2D = null


onready var _pilot_master: CityPilotMaster = get_node(_pilot_master_node)



func enter(parameters: Array = [ ]):
	_item = parameters[0]
	_receiver = parameters[1]
	assert(_item)
	if not _item:
		return
	
	if _receiver:
		_pilot_master.drop_item(_item, _receiver.global_position)
	else:
		_pilot_master.drop_item(_item)
	
	if _receiver is Structure:
		_receiver.check_area_for_item(_item)
	
	_item = null
	_receiver = null
