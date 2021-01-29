class_name ActorStateTake, "res://assets/icons/game_actors/states/icon_state_take.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_2 := ["_puppet_master", "_item"]


var _item: GameResource = null

var _puppet_master: InputMaster = null




func _ready() -> void:
	name = TAKE
	
	if not _puppet_master:
		_puppet_master = get_parent()._puppet_master




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		_item = parameters[0]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String) -> void:
	if not _item:
		return
	
	if _puppet_master.pick_up_item(_item):
		_item = null


func animtion_finished(animation: String) -> void:
	.animtion_finished(animation)
	
	exit(IDLE)
