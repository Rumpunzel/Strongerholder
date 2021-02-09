class_name GameSpritePlayer
extends AnimationPlayer


signal acted
signal action_finished



func animation_finished() -> void:
	emit_signal("animation_finished")
