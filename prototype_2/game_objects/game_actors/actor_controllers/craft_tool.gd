class_name CraftTool, "res://assets/icons/game_actors/icon_crafting_tool.svg"
extends Area2D


# warning-ignore-all:unused_class_variable
export(Array, Constants.Resources) var used_for: Array

export var attack_value: float = 2.0
# warning-ignore-all:unused_class_variable
export(String, "attack", "give") var animation


export(String, DIR) var _tool_sounds: String


onready var _hit_box: CollisionShape2D = $tool_shape

onready var _sounds: Array = FileHelper.list_files_in_directory(_tool_sounds, false, ".wav")
onready var _tool_audio: GameAudioPlayer = $tool_audio

onready var _game_actor = get_parent().owner




func _ready():
	connect("body_entered", self, "_hit_object")




func start_attack():
	_hit_box.disabled = false


func end_attack():
	_hit_box.disabled = true

func is_active() -> bool:
	return true


func _hit_object(other_object: Node2D):
	if other_object == _game_actor:
		return
	
	other_object.damage(attack_value, _game_actor)
	attack_effect()


func attack_effect():
	_tool_audio.play_audio_from_array(_sounds)
