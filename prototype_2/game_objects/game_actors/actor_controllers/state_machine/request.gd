class_name ActorStateRequest, "res://assets/icons/game_actors/states/icon_state_request.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_2 := ["_request", "_receiver", "_puppet_master"]


var _request
var _receiver: Node2D

var _puppet_master: InputMaster = null




func _ready():
	name = REQUEST
	
	if not _puppet_master:
		_puppet_master = get_parent()._puppet_master




func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	if not parameters.empty():
		_request = parameters[0]
		_receiver = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String):
	if _puppet_master.carry_weight_left() > 0.01 and _puppet_master.in_range(_receiver):
		_receiver.request_item(_request, _game_object)


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	exit(IDLE)
