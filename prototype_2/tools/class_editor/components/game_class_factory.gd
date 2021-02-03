class_name GameClassFactory
extends Resource


const _GAME_CLASSES_HEADER := """
class_name GameClasses
extends Resource\n

"""

const _GAME_CLASS := """
class _GameClass:
	static func _spawn(scene: String, type: String, sprite: Texture, properties: Dictionary) -> Node2D:
		var new_game_class: Node2D = load(scene).instance()
		
		for property in properties.keys():
			new_game_class.set(property, properties[property])
		
		return new_game_class

"""

const _CLASS_BLUEPRINT := """
class %s extends _GameClass:
%s
	
%s
	
	const _PROPERTIES := {
%s
	}
	
	static func spawn() -> Node2D:
		return _spawn(%s, TYPE, load(SPRITE), properties)

"""

const _CONSTANT_BLUEPRINT := "const %s := %s"
const _PROPERTY_BLUEPRINT := "%s: %s"



static func create_game_class(new_class_name: String, new_class_scene: String, new_type: String, new_sprite: String, new_properties: Dictionary) -> String:
	var main_properties := {
		"TYPE": new_type,
		"SCENE": new_class_scene,
		"SPRITE": new_sprite,
	}
	
	var class_constants := _properties_to_data(_CONSTANT_BLUEPRINT, main_properties, 1)
	var class_properties := _properties_to_data(_PROPERTY_BLUEPRINT, new_properties, 2)
	
	return _CLASS_BLUEPRINT % [ new_class_name, class_constants, class_properties ]



static func _properties_to_data(blueprint: String, properties: Dictionary, indent: int) -> String:
	var properties_as_vars := ""
	
	for property in properties.keys():
		properties_as_vars += _property_to_string(blueprint, property, properties[property], indent)
	
	return properties_as_vars


static func _property_to_string(blueprint: String, property_name: String, property_value: String, indent: int) -> String:
	var property_string := ""
	
	for _i in range(indent):
		property_string += "\t"
	
	property_string += blueprint % [ property_name, property_value ]
	
	return property_string
