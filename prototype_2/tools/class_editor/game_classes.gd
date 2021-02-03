# Avoid changing this file by hand if you can
class_name GameClasses
extends Resource

const _game_resource_scene := "res://game_objects/resources/game_resource.tscn"
const _spyglass_scene := "res://game_objects/resources/tools/spyglass.tscn"
const _craft_tool_scene := "res://game_objects/resources/tools/craft_tool.tscn"
const _city_structure_scene := "res://game_objects/structures/city_structure_with_point.tscn"
const _structure_scene := "res://game_objects/structures/structure_with_point.tscn"


const CLASSES := {
	"res://game_objects/resources/game_resource.tscn": [
		"Wood",
	],
}

class _GameClass:
	static func _spawn(scene: String, type: String, sprite: Texture, properties: Dictionary) -> Node2D:
		var new_game_class: Node2D = load(scene).instance()
		
		properties["type"] = type
		properties["sprite"] = sprite
		
		for property in properties.keys():
			new_game_class.set(property, properties[property])
		
		return new_game_class


class Wood extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "Wood"
	const sprite := "res://ui/game_gui/resource_icons/icon_wood.png"
	
	const how_many_can_be_carried := 3
	
	const _PROPERTIES := {
		"how_many_can_be_carried": 3,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type, load(sprite), _PROPERTIES)
