class_name CityStructureStateTake, "res://assets/icons/game_actors/states/icon_state_take.svg"
extends CityStructureState


const PERSIST_OBJ_PROPERTIES_3 := ["_item"]


var _item: GameResource = null




func _ready() -> void:
	name = TAKE




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		_item = parameters[0]
	
	
	if not _item:
		return
	
	if pilot_master.pick_up_item(_item):
		_item = null
	
	exit(IDLE)
