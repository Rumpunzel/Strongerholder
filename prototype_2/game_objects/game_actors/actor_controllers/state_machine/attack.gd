class_name ActorStateAttack, "res://assets/icons/game_actors/states/icon_state_attack.svg"
extends ActorState


var _weapon: CraftTool




func enter(parameters: Array = [ ]):
	_weapon = parameters[0]
	
	_animation_cancellable = false
	
	_change_animation(ATTACK)


func animation_acted(_animation: String):
	_weapon.start_attack()


func action_finished(_animation: String):
	_weapon.end_attack()


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	_weapon = null
	
	exit(IDLE)