# Avoid changing this file by hand if you can
class_name GameClasses
extends Resource


const GAME_RESOURCE_SCENE := "res://game_objects/resources/game_resource.tscn"
const SPYGLASS_SCENE := "res://game_objects/resources/tools/spyglass.tscn"
const CRAFT_TOOL_SCENE := "res://game_objects/resources/tools/craft_tool.tscn"
const CITY_STRUCTURE_SCENE := "res://game_objects/city_structures/city_structure.tscn"
const STRUCTURE_SCENE := "res://game_objects/structures/structure.tscn"


const CLASSES := {
	GAME_RESOURCE_SCENE: [
		"WoodLogs",
		"WoodPlanks",
		"Stone",
	],
	CRAFT_TOOL_SCENE: [
		"Axe",
	],
	SPYGLASS_SCENE: [
		"Saw",
	],
	CITY_STRUCTURE_SCENE: [
		"Sawmill",
		"Workshop",
	],
	STRUCTURE_SCENE: [
		"Beech",
	],
}


static func spawn_class_with_name(class_name_to_spawn: String) -> Node2D:
	var lookup_file: GDScript = load("res://game_objects/game_classes.gd")
	var constants: Dictionary = lookup_file.get_script_constant_map()
	var new_class = constants[class_name_to_spawn].spawn()
	
	return new_class


class WoodLogs extends _GameClass:
	const scene := "res://game_objects/resources/game_resource.tscn"
	const type := "WoodLogs"
	const sprite := "res://ui/game_gui/resource_icons/icon_wood.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const can_carry := 3
	const damaged_sounds := "res://assets/sounds/axe/"
	
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
	const damaged_sounds := "res://assets/sounds/axe/"
	
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
	const damaged_sounds := "res://assets/sounds/axe/"
	
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
	const damaged_sounds := "res://assets/sounds/axe/"
	const gathers := {
		"WoodLogs": true,
		"WoodPlanks": false,
		"Stone": false,
		"Saw": false,
		"Axe": false,
	}
	const delivers := {
		"WoodLogs": false,
		"WoodPlanks": true,
		"Stone": false,
		"Saw": false,
		"Axe": false,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Saw extends _GameClass:
	const scene := "res://game_objects/resources/tools/spyglass.tscn"
	const type := "Saw"
	const sprite := "res://assets/sprites/tools/saw.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const can_carry := 1
	const damaged_sounds := "res://assets/sounds/axe/"
	const gathers := {
		"WoodLogs": false,
		"WoodPlanks": true,
		"Stone": false,
		"Saw": false,
		"Axe": false,
	}
	const delivers := {
		"WoodLogs": false,
		"WoodPlanks": false,
		"Stone": false,
		"Saw": false,
		"Axe": true,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Sawmill extends _GameClass:
	const scene := "res://game_objects/city_structures/city_structure.tscn"
	const type := "Sawmill"
	const sprite := "res://assets/sprites/structures/medievalStructure_16.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const production_steps := 2
	const damaged_sounds := "res://assets/sounds/axe/"
	const operated_sounds := "res://assets/sounds/axe/"
	const starting_items := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Stone": 0,
		"Saw": 0,
		"Axe": 1,
	}
	const storage_resources := {
		"WoodLogs": false,
		"WoodPlanks": true,
		"Stone": false,
		"Saw": false,
		"Axe": false,
	}
	const input_resources := {
		"WoodLogs": 1,
		"WoodPlanks": 0,
		"Stone": 0,
		"Saw": 0,
		"Axe": 0,
	}
	const output_resources := {
		"WoodLogs": 0,
		"WoodPlanks": 4,
		"Stone": 0,
		"Saw": 0,
		"Axe": 0,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Workshop extends _GameClass:
	const scene := "res://game_objects/city_structures/city_structure.tscn"
	const type := "Workshop"
	const sprite := "res://assets/sprites/structures/medievalStructure_20.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const production_steps := 2
	const damaged_sounds := "res://assets/sounds/axe/"
	const operated_sounds := "res://assets/sounds/woodsaw"
	const starting_items := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Stone": 0,
		"Saw": 1,
		"Axe": 0,
	}
	const storage_resources := {
		"WoodLogs": false,
		"WoodPlanks": false,
		"Stone": false,
		"Saw": false,
		"Axe": true,
	}
	const input_resources := {
		"WoodLogs": 0,
		"WoodPlanks": 2,
		"Stone": 0,
		"Saw": 0,
		"Axe": 0,
	}
	const output_resources := {
		"WoodLogs": 0,
		"WoodPlanks": 0,
		"Stone": 0,
		"Saw": 0,
		"Axe": 1,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class Beech extends _GameClass:
	const scene := "res://game_objects/structures/structure.tscn"
	const type := "Beech"
	const sprite := "res://assets/sprites/trees/tree1.png"
	
	const hit_points_max := 10
	const indestructible := false
	const maximum_operators := 1
	const damaged_sounds := "res://assets/sounds/axe/"
	const starting_items := {
		"WoodLogs": 3,
		"WoodPlanks": 0,
		"Stone": 0,
		"Saw": 0,
		"Axe": 0,
	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type)


class _GameClass:
	static func _spawn(scene: String, type: String) -> Node2D:
		var new_game_class: Node2D = (load(scene) as PackedScene).instance()
		var class_constants: Dictionary = (load("res://game_objects/game_classes.gd") as GDScript).get_script_constant_map()[type].get_script_constant_map()
		
		new_game_class.name = type
		
		for property in class_constants.keys():
			if property == "scene":
				pass
			else:
				assert(property in new_game_class)
				new_game_class.set(property, class_constants[property])
		
		return new_game_class
