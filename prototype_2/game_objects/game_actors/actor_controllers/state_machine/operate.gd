class_name ActorStateOperate, "res://assets/icons/game_actors/states/icon_state_operate.svg"
extends ActorState


const PERSIST_PROPERTIES_2 := ["_puppet_master_node"]
const PERSIST_OBJ_PROPERTIES_2 := ["_puppet_master", "_structure"]


var _structure: Structure = null

var _puppet_master: InputMaster = null




func _ready():
	name = OPERATE
	
	if not _puppet_master:
		_puppet_master = get_parent()._puppet_master




func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	if not parameters.empty():
		_structure = parameters[0]
	
	_animation_cancellable = false
	
	_change_animation(ATTACK)



func animation_acted(_animation: String):
	if not _structure:
		return
	
	_puppet_master.interact_with(_structure)


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	exit(IDLE)
