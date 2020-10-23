class_name CityStructureStateTake, "res://assets/icons/game_actors/states/icon_state_take.svg"
extends CityStructureState


var _item: GameResource = null



func enter(parameters: Array = [ ]):
	_item = parameters[0]
	
	
	if not _item:
		return
	
	if pilot_master.pick_up_item(_item):
		_item = null
