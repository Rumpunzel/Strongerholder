extends AnimationPlayer


signal attacked
signal stepped


func just_attacked():
	emit_signal("attacked")

func just_stepped():
	emit_signal("stepped")
