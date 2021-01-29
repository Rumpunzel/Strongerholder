class_name CityStructureAudioHandler
extends AudioHandler


export(String, DIR) var _operate_sounds_directory: String


onready var _operate_sounds: Array = FileHelper.list_files_in_directory(_operate_sounds_directory, false, ".wav")



func connect_signals(state_machine: StateMachine):
	.connect_signals(state_machine)
	
	state_machine.connect("operated", self, "_play_operate_audio")



func _play_operate_audio():
	_interaction_audio.play_audio_from_array(_operate_sounds)
