extends AnimationPlayer


signal acted
signal action_finished
signal stepped


export(String, DIR) var _step_sounds: String


onready var _sounds: Array = FileHelper.list_files_in_directory(_step_sounds, false, ".wav")
onready var _footstep_sounds = $FootstepSounds




func just_attacked() -> void:
	emit_signal("acted")

func attack_finished() -> void:
	emit_signal("action_finished")

func just_given() -> void:
	emit_signal("acted")

func just_stepped() -> void:
	_footstep_sounds.play_audio_from_array(_sounds)
	
	emit_signal("stepped")

func animation_finished() -> void:
	emit_signal("animation_finished")
