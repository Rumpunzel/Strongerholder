class_name CityStructureStateTake, "res://class_icons/states/icon_state_take.svg"
extends CityStructureState


const PERSIST_OBJ_PROPERTIES := [ "_item" ]


var _item: GameResource = null




func _ready() -> void:
	name = TAKE




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		_item = parameters[0]
	
	
	if not _item:
		return
	
	emit_signal("took_item")
	
	exit(IDLE)
