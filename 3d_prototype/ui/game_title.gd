class_name GameTitle
extends Label
tool

func _ready():
	text = ProjectSettings.get("application/config/name")
