class_name BuildMenu
extends Control


var _current_dummy: PlacementDummy = null
var _current_structure: Structure = null

var _objects_layer: ObjectsLayer = null setget set_objects_layer


onready var _buttons: VBoxContainer = $Buildings




func _ready() -> void:
	ServiceLocator.connect("objects_layer_changed", self, "set_objects_layer")
	
	var structures_to_place: Array = GameClasses.CLASSES[GameClasses.STRUCTURE_SCENE] + GameClasses.CLASSES[GameClasses.CITY_STRUCTURE_SCENE]
	
	for structure in structures_to_place:
		var new_button := BuildMenuButton.new(structure, self)
		
		new_button.connect("building_placed", self, "place_building")
		
		_buttons.add_child(new_button)



func _unhandled_input(event: InputEvent) -> void:
	if not _current_dummy:
		return
	
	if event.is_action_pressed("place_building"):
		get_tree().set_input_as_handled()
		
		if _current_dummy.place_free():
			_objects_layer.add_child(_current_structure)
			_current_structure.global_position = _current_dummy.get_building_position()
			
			_current_structure = GameClasses.spawn_class_with_name(_current_structure.type)
	elif event.is_action_pressed("place_building_cancel"):
		get_tree().set_input_as_handled()
		
		_delete_blue_print()




func place_building(structure: Structure) -> void:
	_current_structure = structure
	
	var new_collision_shape: CollisionShape2D = _current_structure._get_copy_of_collision_shape()
	var new_sprite: Sprite = _current_structure._get_copy_sprite()
	
	_current_dummy = PlacementDummy.new(new_collision_shape, _current_structure.position, new_sprite, _current_structure.position)
	
	_objects_layer.add_child(_current_dummy)



func set_objects_layer(new_objects_layer: ObjectsLayer):
	_objects_layer = new_objects_layer



func _delete_blue_print() -> void:
	_current_dummy.queue_free()
	_current_dummy = null
	
	if _current_structure:
		_current_structure.queue_free()
		_current_structure = null
