class_name ActorStateRequest, "res://assets/icons/game_actors/states/icon_state_request.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_2 := ["_request", "_receiver"]


var _request
var _receiver: Node2D



func enter(parameters: Array = [ ]):
	if not parameters.empty():
		.enter(parameters)
		
		_request = parameters[0]
		_receiver = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String):
	_receiver.request_item(_request, _game_object)
	
	_request = null
	_receiver = null


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	exit(IDLE)
