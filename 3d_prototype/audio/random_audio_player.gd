class_name RandomAudioPlayer
extends AudioStreamPlayer3D

export(Array, AudioStream) var _streams := [ ]


func play_random() -> void:
	if _streams.empty():
		return
	
	stream = _streams[randi() % _streams.size()]
	play()
	
	yield(self, "finished")
	
	queue_free()
