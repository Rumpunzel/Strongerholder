class_name FPSLabel
extends Label

func _process(_delta: float) -> void:
	text = "%02d FPS" % Engine.get_frames_per_second()
