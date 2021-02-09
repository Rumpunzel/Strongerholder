extends GameAudioPlayer


export(String, DIR) var _step_sounds: String


onready var _sounds: Array = FileHelper.list_files_in_directory(_step_sounds, false, ".wav")




func play_step_sound() -> void:
	play_audio_from_array(_sounds)
