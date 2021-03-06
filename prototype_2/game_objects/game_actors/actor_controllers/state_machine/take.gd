class_name ActorStateTake, "res://class_icons/states/icon_state_take.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES := ["_item"]


var _item: GameResource = null




func _ready() -> void:
	name = TAKE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		_item = parameters[0]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String) -> void:
	if not _item:
		return
	
	emit_signal("took_item", _item)
	
	_item = null


func animation_finished(animation: String) -> void:
	.animation_finished(animation)
	
	exit(IDLE)
