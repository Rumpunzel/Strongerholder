class_name ActorStateAttack, "res://assets/icons/game_actors/states/icon_state_attack.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_2 := ["_weapon"]


var _weapon: CraftTool = null




func _ready():
	name = ATTACK




func enter(parameters: Array = [ ]):
	.enter(parameters)
	
	if not parameters.empty():
		_weapon = parameters[0]
	assert(_weapon)
	_animation_cancellable = false
	
	_change_animation(ATTACK)



func animation_acted(_animation: String):
	_weapon.start_attack(_game_object)


func action_finished(_animation: String):
	_weapon.end_attack()
	
	_weapon = null


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	exit(IDLE)
