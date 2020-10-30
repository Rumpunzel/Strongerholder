class_name ActorStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_2 := ["_item", "_receiver", "_puppet_master"]

const _DROP_OFFSET: Vector2 = Vector2(0, -1)


var _item: GameResource = null
var _receiver: Node2D = null

var _puppet_master: InputMaster = null




func _ready():
	name = GIVE
	
	if not _puppet_master:
		_puppet_master = get_parent()._puppet_master




func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	if not parameters.empty():
		_item = parameters[0]
		_receiver = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String):
	if not _item:
		return
	
	if _receiver:
		_puppet_master.drop_item(_item, _receiver.global_position + _DROP_OFFSET)
	else:
		_puppet_master.drop_item(_item)
	
	if _receiver is Structure:
		_receiver.check_area_for_item(_item)


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	exit(IDLE)
