class_name ClassItem
extends PanelContainer

# warning-ignore-all:unsafe_method_access

const SCENE := "scene"
const TYPE := "type"
const SPRITE := "sprite"
const PROPERTIES := "_PROPERTIES"


export(String, FILE, "*.tscn") var class_scene = ""


onready var _sprite: TextureRect = $MarginContainer/PropertyDivider/IconDivider/Sprite
onready var _resource_name: LineEdit = $MarginContainer/PropertyDivider/IconDivider/ButtonsDivider/ResourceName
onready var _properties: ClassProperties = $MarginContainer/PropertyDivider/Properties




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func setup(class_constants: Dictionary) -> void:
	assert(class_constants[SCENE] == class_scene)
	class_constants.erase(SCENE)
	
	_resource_name.text = class_constants[TYPE]
	class_constants.erase(TYPE)
	_sprite.set_current_image_path(class_constants[SPRITE])
	class_constants.erase(SPRITE)
	
	class_constants.erase(PROPERTIES)
	
	_properties.setup(class_constants)


func get_class_interface() -> GameClassFactory.ClassToStringInterface:
	var class_interface := GameClassFactory.ClassToStringInterface.new(_resource_name.text, _sprite.get_current_image_path(), _properties.get_properties())
	
	return class_interface



func delete() -> void:
	get_parent().remove_child(self)
	queue_free()
