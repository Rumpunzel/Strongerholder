class_name CraftTool, "res://assets/icons/game_actors/icon_crafting_tool.svg"
extends GameResource


# warning-ignore-all:unused_class_variable
export(Array, Constants.Resources) var used_for: Array

export var attack_value: float = 2.0
# warning-ignore-all:unused_class_variable
export(String, "attack", "give") var animation


onready var _hurt_box: HurtBox = $hurt_box
onready var _game_actor: Node2D = owner



func start_attack(_game_actor):
	_hurt_box.start_attack(_game_actor, attack_value)


func end_attack():
	_hurt_box.end_attack()
