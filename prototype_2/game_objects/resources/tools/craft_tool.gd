class_name CraftTool, "res://class_icons/game_objects/resources/icon_crafting_tool.svg"
extends Spyglass


const SCENE_OVERRIDE_2 := "res://game_objects/resources/tools/craft_tool.tscn"

const PERSIST_PROPERTIES_4 := ["attack_value", "animation"]


var attack_value: float = 2.0
# warning-ignore-all:unused_class_variable
var animation: String = "none"


onready var _hurt_box: HurtBox = $HurtBox



func start_attack(game_actor: Node2D) -> void:
	_state_machine.start_attack(game_actor)


func end_attack() -> void:
	_state_machine.end_attack()




func _initialise_state_machine(new_state_machine: ObjectStateMachine = ToolStateMachine.new()) -> void:
	._initialise_state_machine(new_state_machine)
	
	_state_machine.connect("hit_box_enabled", self, "_enable_hurtbox")
	_state_machine.connect("hit_box_disabled", self, "_disable_hurtbox")



func _enable_hurtbox(game_actor: Node2D) -> void:
	_hurt_box.start_attack(game_actor, attack_value)


func _disable_hurtbox() -> void:
	_hurt_box.end_attack()
