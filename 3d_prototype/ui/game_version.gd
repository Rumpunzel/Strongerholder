class_name GameVersion
extends Label
tool

func _ready():
	text = "version-%s" % [ ProjectSettings.get("application/config/version") ]
