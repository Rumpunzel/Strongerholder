class_name ActorStateRequest, "res://class_icons/states/icon_state_request.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_3 := ["_request", "_structure_to_request_from"]


var _request
var _structure_to_request_from: Node2D




func _ready() -> void:
	name = REQUEST




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		_request = parameters[0]
		_structure_to_request_from = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String) -> void:
	emit_signal("item_requested", _request, _structure_to_request_from)


func animation_finished(animation: String) -> void:
	.animation_finished(animation)
	
	exit(IDLE)
