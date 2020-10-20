class_name ActorStateRequest, "res://assets/icons/game_actors/states/icon_state_request.svg"
extends ActorState


var _request
var _receiver: Node2D



func enter(parameters: Array = [ ]):
	_request = parameters[0]
	_receiver = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String):
	_receiver.request_item(_request, _game_object)
	
	_request = null
	_receiver = null
