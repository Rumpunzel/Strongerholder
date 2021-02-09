class_name CityStructureAudioHandler
extends AudioHandler


var _operated_sounds: Array = [ ]



func play_operated_audio() -> void:
	_interaction_audio.play_audio_from_array(_operated_sounds)



func set_operated_sounds(new_sounds: String) -> void:
	_operated_sounds = FileHelper.list_files_in_directory(new_sounds, false, ".wav")
