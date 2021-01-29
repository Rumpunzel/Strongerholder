class_name GameAudioPlayer
extends AudioStreamPlayer2D



func _ready() -> void:
	attenuation = 10



func play_audio_from_array(audio_array: Array) -> void:
	if not audio_array.empty():
		stream = load(audio_array[randi() % audio_array.size()])
		play()
