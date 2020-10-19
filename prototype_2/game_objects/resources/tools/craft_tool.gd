class_name CraftTool, "res://assets/icons/game_actors/icon_crafting_tool.svg"
extends Spyglass


export var attack_value: float = 2.0
# warning-ignore-all:unused_class_variable
export(String, "none", "attack", "give") var animation


onready var _hurt_box: HurtBox = $hurt_box



func start_attack(game_actor: Node2D):
	_state_machine.start_attack(game_actor)


func end_attack():
	_state_machine.end_attack()



func _enable_hurtbox(game_actor: Node2D):
	_hurt_box.start_attack(game_actor, attack_value)


func _disable_hurtbox():
	_hurt_box.end_attack()
