class_name CityStructureStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends CityStructureState


export(NodePath) var _pilot_master_node


var _item: GameResource
var _receiver: Node2D


onready var _pilot_master: CityPilotMaster = get_node(_pilot_master_node)



func enter(parameters: Array = [ ]):
	_item = parameters[0]
	_receiver = parameters[1]
	
	
	if not _item:
		return
	
	if _receiver:
		_pilot_master.drop_item(_item, _receiver.global_position)
	else:
		_pilot_master.drop_item(_item)
	
	_item = null
	_receiver = null
