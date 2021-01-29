class_name ToolState
extends ResourceState


const ATTACK = "attack"




func _ready() -> void:
	name = IDLE




func start_attack(game_actor: Node2D) -> void:
	exit(ATTACK, [game_actor])


func end_attack() -> void:
	pass
