class_name ToolStateAttack, "res://class_icons/game_actors/states/icon_state_attack.svg"
extends ToolStateInactive




func _ready() -> void:
	name = ATTACK




func enter(parameters: Array = [ ]) -> void:
	.enter(parameters)
	
	if not parameters.empty():
		game_object._enable_hurtbox(parameters[0])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	game_object._disable_hurtbox()
	
	.exit(next_state, parameters)



func end_attack() -> void:
	exit(INACTIVE)
