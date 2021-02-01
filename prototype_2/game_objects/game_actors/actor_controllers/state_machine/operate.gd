class_name ActorStateOperate, "res://class_icons/game_actors/states/icon_state_operate.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_3 := ["_structure"]


var _structure: Structure = null




func _ready() -> void:
	name = OPERATE




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		_structure = parameters[0]
	
	_animation_cancellable = false
	
	_change_animation(ATTACK)



func animation_acted(_animation: String) -> void:
	if not _structure:
		return
	
	puppet_master.interact_with(_structure)


func animation_finished(animation: String) -> void:
	.animation_finished(animation)
	
	exit(IDLE)
