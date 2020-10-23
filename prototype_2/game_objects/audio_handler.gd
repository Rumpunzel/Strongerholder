class_name AudioHandler, "res://assets/icons/icon_audio_handler.svg"
extends Node2D


export(NodePath) var _state_machine_node = null

export(String, DIR) var _damage_sounds_directory: String


onready var _damage_sounds: Array = FileHelper.list_files_in_directory(_damage_sounds_directory, false, ".wav")

onready var _interaction_audio: GameAudioPlayer = $interaction_audio




# Called when the node enters the scene tree for the first time.
func _ready():
	var state_machine: ObjectStateMachine
	
	if not _state_machine_node:
		return
	
	state_machine = get_node(_state_machine_node)
	
	_connect_signals(state_machine)




func _connect_signals(state_machine: StateMachine):
	state_machine.connect("damaged", self, "_play_damage_audio")


func _play_damage_audio(damage_taken: float, _sender):
	if damage_taken > 0:
		_interaction_audio.play_audio_from_array(_damage_sounds)
