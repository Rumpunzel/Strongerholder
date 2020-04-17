class_name Tool, "res://assets/icons/game_actors/icon_tool.svg"
extends GameAudioPlayer


export var attack_value: float = 2.0

export(String, DIR) var _tool_sounds: String



onready var _sounds: Array = FileHelper.list_files_in_directory(_tool_sounds, false, ".wav")



func attack(other_hit_box: ObjectHitBox, own_hit_box: ActorHitBox):
	other_hit_box.damage(attack_value, own_hit_box)
	attack_effect(other_hit_box, own_hit_box)


func attack_effect(_other_hit_box: ObjectHitBox, _own_hit_box: ActorHitBox):
	play_audio_from_array(_sounds)
