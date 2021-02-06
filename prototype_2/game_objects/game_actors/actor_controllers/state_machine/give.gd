class_name ActorStateGive, "res://class_icons/states/icon_state_give.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_3 := ["_item", "_receiver"]


var _item: GameResource = null
var _receiver: Node2D = null




func _ready() -> void:
	name = GIVE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		_item = parameters[0]
		_receiver = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String) -> void:
	if not _item:
		return
	
	if _receiver:
		emit_signal("gave_item_to", _item, _receiver)
	else:
		emit_signal("dropped_item", _item)


func animation_finished(animation: String) -> void:
	.animation_finished(animation)
	
	exit(IDLE)
