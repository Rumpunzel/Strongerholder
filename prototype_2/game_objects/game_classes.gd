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
		"Stone",
	],
	"res://game_objects/resources/tools/craft_tool.tscn": [
		"Axe",
		"Saw",
	],
	"res://game_objects/structures/city_structure_with_point.tscn": [
		"WoodcuttersHut",
		"Sawmill",
		"Stockpile",
	],
}


class WoodLogs extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "WoodLogs"
	const sprite := "res://ui/game_gui/resource_icons/icon_wood.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const can_carry := 3
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class WoodPlanks extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "WoodPlanks"
	const sprite := "res://ui/game_gui/resource_icons/icon_wood_planks.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const can_carry := 12
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Timber extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "Timber"
	const sprite := "res://assets/sprites/trees/tree5.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const can_carry := 1
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Stone extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "Stone"
	const sprite := "res://ui/game_gui/resource_icons/icon_stone.png"
	
	const hit_points_max := 50
	const indestructible := false
	const maximum_operators := 1
	const can_carry := 1
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Axe extends _GameClass:
	const scene := "res://game_objects/resources/tools/craft_tool.tscn"
	const type := "Axe"
	const sprite := "res://assets/sprites/tools/axe.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const can_carry := 1
	const attack_value := 2
	const animation := "attack"
	const gathers := {
		"WoodLogs": false,
		"WoodPlanks": false,
		"Timber": true,
		"Stone": false,
	}
	const delivers := {
		"WoodLogs": true,
		"WoodPlanks": false,
		"Timber": false,
		"Stone": false,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Saw extends _GameClass:
	const scene := "res://game_objects/resources/tools/craft_tool.tscn"
	const type := "Saw"
	const sprite := "res://assets/sprites/tools/saw.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const can_carry := 1
	const attack_value := 2
	const animation := "attack"
	const gathers := {
		"WoodLogs": true,
		"WoodPlanks": false,
		"Timber": false,
		"Stone": false,
	}
	const delivers := {
		"WoodLogs": false,
		"WoodPlanks": true,
		"Timber": false,
		"Stone": false,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class WoodcuttersHut extends _GameClass:
	const scene := "res://game_objects/structures/city_structure_with_point.tscn"
	const type := "WoodcuttersHut"
	const sprite := "res://assets/sprites/structures/medievalStructure_16.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const production_steps := 2
	const starting_items := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Timber": 0,
		"Stone": 0,
	}
	const storage_resources := {
		"WoodLogs": false,
		"WoodPlanks": false,
		"Timber": false,
		"Stone": false,
	}
	const input_resources := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Timber": 1,
		"Stone": 0,
	}
	const output_resources := {
		"WoodLogs": 3,
		"WoodPlanks": 0,
		"Timber": 0,
		"Stone": 0,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Sawmill extends _GameClass:
	const scene := "res://game_objects/structures/city_structure_with_point.tscn"
	const type := "Sawmill"
	const sprite := "res://assets/sprites/structures/medievalStructure_21.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const production_steps := 2
	const starting_items := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Timber": 0,
		"Stone": 0,
	}
	const storage_resources := {
		"WoodLogs": false,
		"WoodPlanks": false,
		"Timber": false,
		"Stone": false,
	}
	const input_resources := {
		"WoodLogs": 0,
		"WoodPlanks": 1,
		"Timber": 0,
		"Stone": 0,
	}
	const output_resources := {
		"WoodLogs": 0,
		"WoodPlanks": 4,
		"Timber": 0,
		"Stone": 0,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Stockpile extends _GameClass:
	const scene := "res://game_objects/structures/city_structure_with_point.tscn"
	const type := "Stockpile"
	const sprite := "res://assets/sprites/structures/medievalStructure_19.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const production_steps := 2
	const starting_items := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Timber": 0,
		"Stone": 0,
	}
	const storage_resources := {
		"WoodLogs": true,
		"WoodPlanks": true,
		"Timber": true,
		"Stone": true,
	}
	const input_resources := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Timber": 0,
		"Stone": 0,
	}
	const output_resources := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Timber": 0,
		"Stone": 0,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class _GameClass:
	static func _spawn(scene: String, type: String) -> Node2D:
		var new_game_class: Node2D = load(scene).instance()
		var class_constants: Dictionary = load("res://game_objects/game_classes.gd").get_script_constant_map()[type].get_script_constant_map()
		
		for property in class_constants.keys():
			if property == scene:
				pass
			else:
				new_game_class.set(property, class_constants[property])
		
		return new_game_class
