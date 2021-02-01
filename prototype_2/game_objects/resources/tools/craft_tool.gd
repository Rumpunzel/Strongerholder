class_name CraftTool, "res://class_icons/game_objects/resources/icon_crafting_tool.svg"
extends Spyglass


const PERSIST_PROPERTIES_4 := ["attack_value", "animation"]


export var attack_value: float = 2.0
# warning-ignore-all:unused_class_variable
export(String, "none", "attack", "give") var animation


onready var _hurt_box: HurtBox = $HurtBox



func start_attack(game_actor: Node2D) -> void:
	_state_machine.start_attack(game_actor)


func end_attack() -> void:
	_state_machine.end_attack()



func _enable_hurtbox(game_actor: Node2D) -> void:
	_hurt_box.start_attack(game_actor, attack_value)


func _disable_hurtbox() -> void:
	_hurt_box.end_attack()



func _initialise_state_machine() -> void:
	_state_machine = ToolStateMachine.new()
	_state_machine.name = "state_machine"
	_state_machine.game_object = self
	
	add_child(_state_machine)
