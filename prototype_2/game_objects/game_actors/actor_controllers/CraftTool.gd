class_name CraftTool, "res://assets/icons/game_actors/icon_crafting_tool.svg"
extends Node2D


export(Array, Constants.Structures) var used_for: Array

export var attack_value: float = 2.0
export(String, "attack", "give") var animation


export(String, DIR) var _tool_sounds: String


onready var _sounds: Array = FileHelper.list_files_in_directory(_tool_sounds, false, ".wav")



func check_for_interaction(other_hit_box: ObjectHitBox):
	if used_for.has(other_hit_box.type):
		return true
	
	return false


func interact_with(other_hit_box: ObjectHitBox, own_hit_box: ActorHitBox, tool_belt: ToolBelt):
	other_hit_box.damage(attack_value, own_hit_box)
	attack_effect(other_hit_box, own_hit_box, tool_belt)


func attack_effect(_other_hit_box: ObjectHitBox, _own_hit_box: ActorHitBox, tool_belt: ToolBelt):
	tool_belt.play_audio_from_array(_sounds)
