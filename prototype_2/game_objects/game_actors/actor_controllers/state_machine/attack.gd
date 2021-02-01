class_name ActorStateAttack, "res://assets/icons/game_actors/states/icon_state_attack.svg"
extends ActorState


const PERSIST_OBJ_PROPERTIES_3 := ["_weapon"]


var _weapon: CraftTool = null




func _ready() -> void:
	name = ATTACK




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		_weapon = parameters[0]
	assert(_weapon)
	_animation_cancellable = false
	
	_change_animation(ATTACK)



func animation_acted(_animation: String) -> void:
	_weapon.start_attack(game_object)


func action_finished(_animation: String) -> void:
	_weapon.end_attack()


func animation_finished(animation: String) -> void:
	.animation_finished(animation)
	
	exit(IDLE)
