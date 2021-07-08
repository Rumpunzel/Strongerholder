extends Spatial
tool

export var _text := "Text"


func _ready() -> void:
	if Engine.editor_hint:
		visible = true
		$Viewport/CanvasLayer/CenterContainer/PanelContainer/Label.text = _text
	else:
		visible = false
		set_process(false)
