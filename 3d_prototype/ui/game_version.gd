class_name GameVersion
extends Label
tool


func _ready():
	text = "version %s" % version_as_string(true)



static func version_as_string(with_postfix := false) -> String:
	var version := "%d.%d.%d"
	
	if with_postfix:
		var postfix: String = ProjectSettings.get("application/config/version_postfix")
		version += " %s" % postfix
	
	return version % [ major_version(), minor_version(), patch_version() ]


static func major_version() -> int:
	return ProjectSettings.get("application/config/version_major")

static func minor_version() -> int:
	return ProjectSettings.get("application/config/version_minor")

static func patch_version() -> int:
	return ProjectSettings.get("application/config/version_patch")
