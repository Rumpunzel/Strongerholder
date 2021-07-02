extends Spatial
tool

func _ready() -> void:
	if Engine.editor_hint:
		visible = true
	else:
		visible = false
		set_process(false)
