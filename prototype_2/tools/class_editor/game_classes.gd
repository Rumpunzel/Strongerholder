class_name GameClasses
extends Resource


class Wood extends _GameClass:
	const _GAME_RESOURCE_SCENE: String = "res://game_objects/resources/game_resource.tscn"
	const TYPE: String = "Wood"
	const SPRITE: String = "res://ui/game_gui/resource_icons/icon_wood.png"
	
	const HOW_MANY_CAN_BE_CARRIED: int = 3
	
	static func spawn() -> Node2D:
		var properties := {
			"how_many_can_be_carried": HOW_MANY_CAN_BE_CARRIED,
		}
		
		return _spawn(_GAME_RESOURCE_SCENE, TYPE, load(SPRITE), properties)


class WoodcuttersHut extends _GameClass:
	const _GAME_RESOURCE_SCENE: String = "res://game_objects/structures/city_structure_with_point.tscn"
	const TYPE: String = "WoodcuttersHut"
	const SPRITE: String = "res://assets/sprites/structures/medievalStructure_16.png"
	
	const STARTING_ITEMS: Array = [ "Axe" ]
	const AVAILABLE_JOB = "res://city_management/job_machine/job_machine.gd"
	const STORAGE_RESOURCES: Array = [  ]
	const INPUT_RESOURCES: Array = [ "Wood" ]
	const OUTPUT_RESOURCES: Array = [ "Wood", "Wood" ]
	const PRODUCTION_STEPS: int = 2
	const DAMAGE_SOUNDS: String = "res://assets/sounds/axe"
	const OPERATE_SOUNDS: String ="res://assets/sounds/axe"
	const VOLUME_MODIFIER: float = -6.0
	
	static func spawn() -> Node2D:
		var properties := {
			"starting_items": STARTING_ITEMS,
			"available_job": AVAILABLE_JOB,
			"input_resources": INPUT_RESOURCES,
			"output_resources": OUTPUT_RESOURCES,
			"storage_resources": STORAGE_RESOURCES,
			"production_steps": PRODUCTION_STEPS,
			"damage_sounds": DAMAGE_SOUNDS,
			"operate_sounds": OPERATE_SOUNDS,
			"volume_modifier": VOLUME_MODIFIER,
		}
		
		return _spawn(_GAME_RESOURCE_SCENE, TYPE, load(SPRITE), properties)



class _GameClass:
	static func _spawn(scene: String, type: String, sprite: Texture, properties: Dictionary) -> Node2D:
		var new_game_class: Node2D = load(scene).instance()
		
		for property in properties.keys():
			new_game_class.set(property, properties[property])
		
		return new_game_class
