class_name ActorStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends ActorState


const PERSIST_PROPERTIES_2 := ["_puppet_master_node"]
const PERSIST_OBJ_PROPERTIES_2 := ["_puppet_master", "_item", "_receiver"]


export(NodePath) var _puppet_master_node


var _puppet_master: InputMaster = null

var _item: GameResource = null
var _receiver: Node2D = null




func _ready():
	if not _puppet_master:
		_puppet_master = get_node(_puppet_master_node)




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
		_puppet_master.drop_item(_item, _receiver.global_position)
	else:
		_puppet_master.drop_item(_item)
	
	if _receiver is Structure:
		_receiver.check_area_for_item(_item)
	
	_item = null
	_receiver = null


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	exit(IDLE)
