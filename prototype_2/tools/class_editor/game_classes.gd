# Avoid changing this file by hand if you can
class_name GameClasses
extends Resource


const _GAME_RESOURCE_SCENE := "res://game_objects/resources/game_resource.tscn"
const _SPYGLASS_SCENE := "res://game_objects/resources/tools/spyglass.tscn"
const _CRAFT_TOOL_SCENE := "res://game_objects/resources/tools/craft_tool.tscn"
const _CITY_STRUCTURE_SCENE := "res://game_objects/structures/city_structure_with_point.tscn"
const _STRUCTURE_SCENE := "res://game_objects/structures/structure_with_point.tscn"


const CLASSES := {
	"res://game_objects/resources/game_resource.tscn": [
		"WoodLogs",
		"WoodPlanks",
		"Timber",
	],
	"res://game_objects/resources/tools/craft_tool.tscn": [
		"Axe",
		"Saw",
	],
	"res://game_objects/resources/tools/spyglass.tscn": [
		"SpyglassType",
	],
}


class WoodLogs extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "WoodLogs"
	const sprite := "res://ui/game_gui/resource_icons/icon_wood.png"
	
	const how_many_can_be_carried := 3
	
	const _PROPERTIES := {
		"how_many_can_be_carried": how_many_can_be_carried,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type, load(sprite), _PROPERTIES)


class WoodPlanks extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "WoodPlanks"
	const sprite := "res://ui/game_gui/resource_icons/icon_wood_planks.png"
	
	const how_many_can_be_carried := 12
	
	const _PROPERTIES := {
		"how_many_can_be_carried": how_many_can_be_carried,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type, load(sprite), _PROPERTIES)


class Timber extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "Timber"
	const sprite := "res://assets/sprites/trees/tree5.png"
	
	const how_many_can_be_carried := 1
	
	const _PROPERTIES := {
		"how_many_can_be_carried": how_many_can_be_carried,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type, load(sprite), _PROPERTIES)


class Axe extends _GameClass:
	const scene := "res://game_objects/resources/tools/craft_tool.tscn"
	const type := "Axe"
	const sprite := "res://assets/sprites/tools/axe.png"
	
	const how_many_can_be_carried := 1
	const gathers := {
		"WoodLogs": false,
		"WoodPlanks": false,
		"Timber": true,
	}
	const delivers := {
		"WoodLogs": true,
		"WoodPlanks": false,
		"Timber": false,
	}
	const attack_value := 2
	const animation := "attack"
	
	const _PROPERTIES := {
		"how_many_can_be_carried": how_many_can_be_carried,
		"gathers": gathers,
		"delivers": delivers,
		"attack_value": attack_value,
		"animation": animation,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type, load(sprite), _PROPERTIES)


class Saw extends _GameClass:
	const scene := "res://game_objects/resources/tools/craft_tool.tscn"
	const type := "Saw"
	const sprite := "res://assets/sprites/tools/saw.png"
	
	const how_many_can_be_carried := 1
	const gathers := {
		"WoodLogs": true,
		"WoodPlanks": false,
		"Timber": false,
	}
	const delivers := {
		"WoodLogs": false,
		"WoodPlanks": true,
		"Timber": false,
	}
	const attack_value := 2
	const animation := "attack"
	
	const _PROPERTIES := {
		"how_many_can_be_carried": how_many_can_be_carried,
		"gathers": gathers,
		"delivers": delivers,
		"attack_value": attack_value,
		"animation": animation,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type, load(sprite), _PROPERTIES)


class SpyglassType extends _GameClass:
	const scene := "res://game_objects/resources/tools/spyglass.tscn"
	const type := "SpyglassType"
	const sprite := "res://ui/game_gui/resource_icons/icon_wood.png"
	
	const how_many_can_be_carried := 3
	const gathers := {
		"WoodLogs": false,
		"WoodPlanks": false,
		"Timber": false,
	}
	const delivers := {
		"WoodLogs": false,
		"WoodPlanks": false,
		"Timber": false,
	}
	
	const _PROPERTIES := {
		"how_many_can_be_carried": how_many_can_be_carried,
		"gathers": gathers,
		"delivers": delivers,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type, load(sprite), _PROPERTIES)


class _GameClass:
	static func _spawn(scene: String, type: String, sprite: Texture, properties: Dictionary) -> Node2D:
		var new_game_class: Node2D = load(scene).instance()
		
		properties["type"] = type
		properties["sprite"] = sprite
		
		for property in properties.keys():
			new_game_class.set(property, properties[property])
		
		return new_game_class
