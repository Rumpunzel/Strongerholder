class_name ActorStateAttack, "res://assets/icons/game_actors/states/icon_state_attack.svg"
extends ActorState


var _target: Object
var _weapon: CraftTool




func enter(parameters: Array = [ ]):
	_target = parameters[0]
	_weapon = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(ATTACK)


func animation_acted(_animation: String):
	_weapon.start_attack()
	print("attacked")


func action_finished(_animation: String):
	_weapon.end_attack()


func animtion_finished(animation: String):
	.animtion_finished(animation)
	
	exit(IDLE)
