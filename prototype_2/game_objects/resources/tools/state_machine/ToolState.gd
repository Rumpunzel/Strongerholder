class_name ToolState
extends ResourceState


const ATTACK = "attack"



func start_attack(game_actor: Node2D):
	exit(ATTACK, [game_actor])


func end_attack():
	pass
