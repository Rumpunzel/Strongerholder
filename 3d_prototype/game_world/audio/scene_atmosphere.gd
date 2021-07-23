class_name SceneAtmosphere
extends AudioStreamPlayer

onready var _tween: Tween = $Tween
onready var _starting_volume := volume_db


func play_atmosphere(audio: AudioStream, fade_in_duration := 1.0) -> void:
	if stream == audio:
		return
	
	stop_atmosphere(fade_in_duration)
	
	if fade_in_duration > 0.0:
		yield(_tween, "tween_all_completed")
	
	stream = audio
	
	if fade_in_duration > 0.0:
		# warning-ignore:return_value_discarded
		_tween.interpolate_property(self, "volume_db", -80.0, _starting_volume, fade_in_duration)
		# warning-ignore:return_value_discarded
		_tween.start()
	
	play()


func stop_atmosphere(fade_out_duration := 1.0) -> void:
	if fade_out_duration > 0.0:
		# warning-ignore:return_value_discarded
		_tween.interpolate_property(self, "volume_db", null, -80.0, fade_out_duration)
		# warning-ignore:return_value_discarded
		_tween.start()
	else:
		stop()
