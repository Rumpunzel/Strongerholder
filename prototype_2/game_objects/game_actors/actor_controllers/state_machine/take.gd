class_name ActorStateTake, "res://assets/icons/game_actors/states/icon_state_take.svg"
extends ActorState


const PERSIST_PROPERTIES_2 := ["_puppet_master_node"]
const PERSIST_OBJ_PROPERTIES_2 := ["_puppet_master", "_item"]


export(NodePath) var _puppet_master_node


var _puppet_master: InputMaster = null

var _item: GameResource = null




func _ready():
	if not _puppet_master:
		_puppet_master = get_node(_puppet_master_node)




func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	if not parameters.empty():
		_item = parameters[0]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String):
	if not _item:
		return
	
	if _puppet_master.pick_up_item(_item):
		_item = null


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	exit(IDLE)
