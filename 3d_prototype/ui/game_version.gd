class_name GameVersion
extends Label
tool

func _ready():
	text = "VERSION-%s" % [ ProjectSettings.get("application/config/version") ]
