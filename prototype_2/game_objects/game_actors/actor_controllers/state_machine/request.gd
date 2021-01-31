class_name ActorStateRequest, "res://assets/icons/game_actors/states/icon_state_request.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_3 := ["_request", "_receiver"]


var _request
var _receiver: Node2D




func _ready() -> void:
	name = REQUEST




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		_request = parameters[0]
		_receiver = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String) -> void:
	if puppet_master.carry_weight_left() > 0.01 and puppet_master.in_range(_receiver):
		_receiver.request_item(_request, game_object)


func animtion_finished(animation: String) -> void:
	.animtion_finished(animation)
	
	exit(IDLE)
