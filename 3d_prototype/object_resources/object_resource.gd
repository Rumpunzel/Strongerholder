class_name ObjectResource
extends Resource

# warning-ignore-all:unused_class_variable
export var name: String
export(Texture) var icon: Texture

export(String, FILE, "*.tscn") var _scene


func spawn() -> Spatial:
	var loaded_scene := load(_scene) as PackedScene
	return loaded_scene.instance() as Spatial


func _to_string() -> String:
	return "Name: %s, Icon: %s, Scene: %s" % [ name, icon, _scene ]
