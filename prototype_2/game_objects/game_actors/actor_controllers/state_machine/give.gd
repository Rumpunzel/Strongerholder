class_name ActorStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_2 := ["_item", "_receiver", "_puppet_master"]


var _item: GameResource = null
var _receiver: Node2D = null

var _puppet_master: InputMaster = null




func _ready() -> void:
	name = GIVE
	
	if not _puppet_master:
		_puppet_master = get_parent()._puppet_master




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
		if _puppet_master.in_range(_receiver.get_parent()):
			_receiver.transfer_item(_item)
	else:
		_puppet_master.drop_item(_item)


func animtion_finished(animation: String) -> void:
	.animtion_finished(animation)
	
	exit(IDLE)
