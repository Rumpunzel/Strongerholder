extends AnimationPlayer


signal acted
signal stepped


onready var footstep_sounds = $footstep_sounds




func _ready():
	connect("stepped", footstep_sounds, "play_step_sound")




func just_attacked():
	emit_signal("acted")

func just_given():
	emit_signal("acted")

func just_stepped():
	emit_signal("stepped")
