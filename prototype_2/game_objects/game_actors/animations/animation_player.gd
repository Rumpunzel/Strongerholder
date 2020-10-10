extends AnimationPlayer


signal acted
signal stepped


func just_attacked():
	emit_signal("acted")

func just_given():
	emit_signal("acted")

func just_stepped():
	emit_signal("stepped")
