extends AnimationPlayer


signal attacked
signal given
signal stepped


func just_attacked():
	emit_signal("attacked")

func just_given():
	emit_signal("given")

func just_stepped():
	emit_signal("stepped")
