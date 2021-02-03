class_name GameClassFactory
extends Resource


const _CLASS_NAME := "GameClasses"
const _FILE_LOCATION := "res://tools/class_editor/game_classes.gd"


const _GAME_RESOURCE_SCENE := "res://game_objects/resources/game_resource.tscn"
const _SPYGLASS_SCENE := "res://game_objects/resources/tools/spyglass.tscn"
const _CRAFT_TOOL_SCENE := "res://game_objects/resources/tools/craft_tool.tscn"

const _CITY_STRUCTURE_SCENE := "res://game_objects/structures/city_structure_with_point.tscn"
const _STRUCTURE_SCENE := "res://game_objects/structures/structure_with_point.tscn"


const _GAME_CLASSES_HEADER := """# Avoid changing this file by hand if you can
class_name %s
extends Resource

%s
"""

const _CLASS_DICTIONARY := """
const CLASSES := {%s}
"""

const _BASE_CLASS := """
class _GameClass:
	static func _spawn(scene: String, type: String, sprite: Texture, properties: Dictionary) -> Node2D:
		var new_game_class: Node2D = load(scene).instance()
		
		properties[\"type\"] = type
		properties[\"sprite\"] = sprite
		
		for property in properties.keys():
			new_game_class.set(property, properties[property])
		
		return new_game_class

"""

const _CLASS_BLUEPRINT := """
class %s extends _GameClass:
%s	
%s	
	const _PROPERTIES := {
%s	}
	
	static func spawn() -> Node2D:
		return _spawn(scene, type, load(sprite), _PROPERTIES)
"""


const _CLASS_ARRAY_BLUEPRINT := """
	\"%s\": [
		\"%s\",
	],
"""


const _CONSTANT_BLUEPRINT := "const %s := %s\n"
const _PROPERTY_BLUEPRINT := "\"%s\": %s,\n"




class ClassToStringInterface:
	var scene: String
	var type: String
	var sprite: String
	var properties: Dictionary
	
	func _init(new_class_scene: String, new_type: String, new_sprite: String, new_properties: Dictionary) -> void:
		scene = new_class_scene
		type = new_type
		sprite = new_sprite
		properties = new_properties



static func create_file(class_interfaces: Array) -> void:
	# Initialise the class header with class declaration
	#	and a list of constants with the class scenes
	var file_string := _GAME_CLASSES_HEADER % [ _CLASS_NAME, _properties_to_data(_CONSTANT_BLUEPRINT, _get_scene_dictionary(), 0) ]
	
	# Continue adding all the non-base classes
	var scene_name_dictionary := { }
	
	# Add pairs of scenes to types to scene_name_dictionary
	for interface in class_interfaces:
		scene_name_dictionary[interface.scene] = scene_name_dictionary.get(interface.scene, [ ])
		scene_name_dictionary[interface.scene].append(interface.type)
	
	# Then add convert scene_name_dictionary as a dictionary of arays to the file
	file_string += _CLASS_DICTIONARY % _properties_to_data(_CLASS_ARRAY_BLUEPRINT, scene_name_dictionary, 0)
	
	# Add the spawn method
	file_string += _BASE_CLASS
	
	
	# Then go through the entire array of interfaces
	#	and add the according class strings
	for interface in class_interfaces:
		file_string += _create_game_class(interface)
	
	
	# Open a new file to write into
	var file = File.new()
	file.open(_FILE_LOCATION, File.WRITE)
	file.store_string(file_string)
	file.close()




static func _create_game_class(class_interface: ClassToStringInterface) -> String:
	var main_properties := {
		"scene": class_interface.scene,
		"type": class_interface.type,
		"sprite": class_interface.sprite,
	}
	
	var class_constants := _properties_to_data(_CONSTANT_BLUEPRINT, main_properties, 1)
	var class_properties := _properties_to_data(_CONSTANT_BLUEPRINT, class_interface.properties, 1)
	var properties := _properties_to_data(_PROPERTY_BLUEPRINT, class_interface.properties, 2)
	
	return _CLASS_BLUEPRINT % [ class_interface.type, class_constants, class_properties, properties ]




static func _properties_to_data(blueprint: String, properties: Dictionary, indent: int) -> String:
	var properties_as_vars := ""
	
	for property in properties.keys():
		properties_as_vars += _property_to_string(blueprint, property.to_lower(), properties[property], indent)
	
	return properties_as_vars


static func _property_to_string(blueprint: String, property_name: String, property_value, indent: int) -> String:
	var property_string := ""
	
	for _i in range(indent):
		property_string += "\t"
	
	property_string += blueprint % [ property_name, ("\"%s\"" if typeof(property_value) == TYPE_STRING else "%s") % property_value ]
	
	return property_string


static func _get_scene_dictionary() -> Dictionary:
	var scene_dictionary := {
		"_GAME_RESOURCE_SCENE": _GAME_RESOURCE_SCENE,
		"_SPYGLASS_SCENE": _SPYGLASS_SCENE,
		"_CRAFT_TOOL_SCENE": _CRAFT_TOOL_SCENE,
		"_CITY_STRUCTURE_SCENE": _CITY_STRUCTURE_SCENE,
		"_STRUCTURE_SCENE": _STRUCTURE_SCENE,
	}
	
	return scene_dictionary
