class_name ObjectResource
extends Resource

# warning-ignore-all:unused_class_variable
export var name: String
export(Texture) var icon
export(String, FILE, "*.tscn") var scene


func _to_string() -> String:
	return "Name: %s, Icon: %s, Scene: %s" % [ name, icon, scene ]
