class_name AudioHandler, "res://assets/icons/icon_audio_handler.svg"
extends Node2D


export(String, DIR) var _damage_sounds_directory: String

export var _volume_modifer: float = 0.0


onready var _damage_sounds: Array = FileHelper.list_files_in_directory(_damage_sounds_directory, false, ".wav")

onready var _interaction_audio: GameAudioPlayer = $interaction_audio




func _ready() -> void:
	_interaction_audio.volume_db += _volume_modifer



func connect_signals(state_machine: StateMachine) -> void:
	state_machine.connect("damaged", self, "_play_damage_audio")



func _play_damage_audio(damage_taken: float, _sender) -> void:
	if damage_taken > 0:
		_interaction_audio.play_audio_from_array(_damage_sounds)
