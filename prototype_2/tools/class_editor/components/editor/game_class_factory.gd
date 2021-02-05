class_name GameClassFactory
extends Resource


signal file_created


const _CLASS_NAME := "GameClasses"
const _FILE_LOCATION := "res://game_objects/game_classes.gd"


const _GAME_RESOURCE_SCENE := "res://game_objects/resources/game_resource.tscn"
const _SPYGLASS_SCENE := "res://game_objects/resources/tools/spyglass.tscn"
const _CRAFT_TOOL_SCENE := "res://game_objects/resources/tools/craft_tool.tscn"

const _CITY_STRUCTURE_SCENE := "res://game_objects/structures/city_structure.tscn"
const _STRUCTURE_SCENE := "res://game_objects/structures/structure.tscn"


const _GAME_CLASSES_HEADER := """# Avoid changing this file by hand if you can
class_name %s
extends Resource


%s
"""

const _CLASS_DICTIONARY := """
const CLASSES := {
%s}

"""

const _SPAWN_FUNCTION := """
static func spawn_class_with_name(class_name_to_spawn: String) -> Node2D:
	var lookup_file: GDScript = load(\"res://game_objects/game_classes.gd\")
	var constants: Dictionary = lookup_file.get_script_constant_map()
	var new_class = constants[class_name_to_spawn].spawn()
	
	return new_class

"""

const _BASE_CLASS := """
class _GameClass:
	static func _spawn(scene: String, type: String) -> Node2D:
		var new_game_class: Node2D = load(scene).instance()
		var class_constants: Dictionary = load(\"res://game_objects/game_classes.gd\").get_script_constant_map()[type].get_script_constant_map()
		
		new_game_class.name = type
		
		for property in class_constants.keys():
			if property == \"scene\":
				pass
			else:
				assert(property in new_game_class)
				new_game_class.set(property, class_constants[property])
		
		return new_game_class
"""

const _CLASS_BLUEPRINT := """
class %s extends _GameClass:
%s	
%s	
	static func spawn() -> Node2D:
		return _spawn(scene, type)

"""


const _CONSTANT_BLUEPRINT := "const %s := %s\n"
const _PROPERTY_BLUEPRINT := "\"%s\": %s,\n"
const _VARIABLE_BLUEPRINT := "%s: %s,\n"

const _ARRAY_BLUEPRINT := "[\n%s"
const _DICTIONARY_BLUEPRINT := "{\n%s"




class ClassToStringInterface:
	var scene: String
	var type: String
	var sprite: String
	var properties: Dictionary
	
	func _init(new_type: String, new_sprite: String, new_properties: Dictionary) -> void:
		type = new_type
		sprite = new_sprite
		properties = new_properties
	
	func _to_string() -> String:
		return "{ #Interface# type: %s, sprite: %s, properties: %s }" % [ type, sprite, properties ]



func create_file(class_interfaces: Dictionary) -> void:
	# Initialise the class header with class declaration
	#	and a list of constants with the class scenes
	var file_string := _GAME_CLASSES_HEADER % [ _CLASS_NAME, _properties_to_data(_CONSTANT_BLUEPRINT, _get_scene_dictionary(), 0) ]
	
	# Continue adding all the non-base classes
	var scene_name_dictionary := { }
	
	# Add pairs of scenes to types to scene_name_dictionary
	for class_of_interfaces in class_interfaces.keys():
		var array_of_classes: Array = class_interfaces[class_of_interfaces]
		
		for game_class in array_of_classes:
			var class_scene_constance := _get_scene_constant_name(class_of_interfaces)
			scene_name_dictionary[class_scene_constance] = scene_name_dictionary.get(class_scene_constance, [ ])
			scene_name_dictionary[class_scene_constance].append(game_class.type)
	
	# Then add convert scene_name_dictionary as a dictionary of arays to the file
	file_string += _CLASS_DICTIONARY % _properties_to_data(_VARIABLE_BLUEPRINT, scene_name_dictionary, 1)
	file_string += _SPAWN_FUNCTION
	
	
	# Then go through the entire array of interfaces
	#	and add the according class strings
	for class_of_interfaces in scene_name_dictionary.keys():
		var array_of_classes: Array = class_interfaces[_get_scene_dictionary()[class_of_interfaces]]
		
		for game_class in array_of_classes:
			game_class.scene = _get_scene_dictionary()[class_of_interfaces]
			file_string += _create_game_class(game_class)
	
	
	# Add the spawn method
	file_string += _BASE_CLASS
	
	#print(file_string)
	# Open a new file to write into
	var file = File.new()
	file.open(_FILE_LOCATION, File.WRITE)
	file.store_string(file_string)
	file.close()
	
	emit_signal("file_created")




func _create_game_class(class_interface: ClassToStringInterface) -> String:
	var main_properties := {
		"scene": class_interface.scene,
		"type": class_interface.type,
		"sprite": class_interface.sprite,
	}
	
	var class_constants := _properties_to_data(_CONSTANT_BLUEPRINT, main_properties, 1)
	var class_properties := _properties_to_data(_CONSTANT_BLUEPRINT, class_interface.properties, 1)
	
	return _CLASS_BLUEPRINT % [ class_interface.type, class_constants, class_properties ]




func _properties_to_data(blueprint: String, properties: Dictionary, indent: int, property_is_variable: bool = false) -> String:
	var properties_as_vars := ""
	
	for property in properties.keys():
		properties_as_vars += _property_to_string(blueprint, property, properties[property], indent, property_is_variable)
	
	return properties_as_vars


func _property_to_string(blueprint: String, property_name: String, property_value, indent: int, property_is_variable: bool) -> String:
	var property_string := ""
	
	for _i in range(indent):
		property_string += "\t"
	
	
	var value_string: String
	
	if property_is_variable:
		value_string = "%s" % property_value
	else:
		match typeof(property_value):
			TYPE_STRING:
				value_string = "\"%s\"" % property_value
			
			TYPE_ARRAY:
				var array_properties := ""
				
				for value in property_value:
					array_properties += _properties_to_data("%s%s,\n", { "": value }, indent + 1)
				
				value_string = _ARRAY_BLUEPRINT % array_properties
				
				for _i in range(indent):
					value_string += "\t"
				
				value_string += "]"
			
			TYPE_DICTIONARY:
				var dict_properties := _properties_to_data(_PROPERTY_BLUEPRINT, property_value , indent + 1)
				value_string = _DICTIONARY_BLUEPRINT % dict_properties
				
				for _i in range(indent):
					value_string += "\t"
				
				value_string += "}"
			
			TYPE_INT:
				value_string = "%d" % property_value
			
			TYPE_REAL:
				value_string = "%f" % property_value
			
			TYPE_BOOL:
				value_string = "%s" % property_value
				value_string = value_string.to_lower()
			
			_:
				print("found no type")
				print(property_value)
				value_string = "%s" % property_value
	
	property_string += blueprint % [ property_name, value_string ]
	
	return property_string



func _get_scene_dictionary() -> Dictionary:
	var scene_dictionary := {
		"_GAME_RESOURCE_SCENE": _GAME_RESOURCE_SCENE,
		"_SPYGLASS_SCENE": _SPYGLASS_SCENE,
		"_CRAFT_TOOL_SCENE": _CRAFT_TOOL_SCENE,
		"_CITY_STRUCTURE_SCENE": _CITY_STRUCTURE_SCENE,
		"_STRUCTURE_SCENE": _STRUCTURE_SCENE,
	}
	
	return scene_dictionary


func _get_scene_constant_name(scene_path: String) -> String:
	var scene_dictionary := {
		_GAME_RESOURCE_SCENE: "_GAME_RESOURCE_SCENE",
		_SPYGLASS_SCENE: "_SPYGLASS_SCENE",
		_CRAFT_TOOL_SCENE: "_CRAFT_TOOL_SCENE",
		_CITY_STRUCTURE_SCENE: "_CITY_STRUCTURE_SCENE",
		_STRUCTURE_SCENE: "_STRUCTURE_SCENE",
	}
	
	return scene_dictionary[scene_path]
