class_name CityStructureStateGive, "res://class_icons/states/icon_state_give.svg"
extends CityStructureState


const PERSIST_OBJ_PROPERTIES_3 := ["_item", "_receiver"]


var _item: GameResource = null
var _receiver: Node2D = null




func _ready() -> void:
	name = GIVE




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		_item = parameters[0]
		_receiver = parameters[1]
	
	if _receiver:
		_receiver.transfer_item(_item)
	else:
		emit_signal("item_dropped", _item)
	
	_item = null
	_receiver = null
	
	exit(IDLE)
