class_name ToolState
extends ResourceState


# warning-ignore:unused_signal
signal hit_box_enabled
# warning-ignore:unused_signal
signal hit_box_disabled


const ATTACK = "Attack"




func _ready() -> void:
	name = IDLE




func start_attack(game_actor) -> void:
	exit(ATTACK, [game_actor])


func end_attack() -> void:
	pass
