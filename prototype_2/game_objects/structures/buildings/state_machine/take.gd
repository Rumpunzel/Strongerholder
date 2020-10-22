class_name CityStructureStateTake, "res://assets/icons/game_actors/states/icon_state_take.svg"
extends CityStructureState


export(NodePath) var _pilot_master_node


var _item: GameResource = null


onready var _pilot_master: CityPilotMaster = get_node(_pilot_master_node)



func enter(parameters: Array = [ ]):
	_item = parameters[0]
	
	
	if not _item:
		return
	
	if _pilot_master.pick_up_item(_item):
		_item = null
