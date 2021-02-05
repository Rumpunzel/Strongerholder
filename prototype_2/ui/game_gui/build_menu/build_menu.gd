class_name BuildMenu
extends Control


var _current_dummies: Array = [ ]
var _current_structure: Node2D = null

var _objects_layer: ObjectsLayer = null setget set_objects_layer


onready var _buttons: VBoxContainer = $Buildings




func _ready() -> void:
	ServiceLocator.connect("objects_layer_changed", self, "set_objects_layer")
	
	for structure in GameClasses.CLASSES[GameClasses.STRUCTURE_SCENE]:
		var new_button := BuildMenuButton.new(structure, self)
		
		_buttons.add_child(new_button)
	
	for structure in GameClasses.CLASSES[GameClasses.CITY_STRUCTURE_SCENE]:
		var new_button := BuildMenuButton.new(structure, self)
		
		_buttons.add_child(new_button)



func _unhandled_input(event: InputEvent) -> void:
	if _current_dummies.empty():
		return
	
	if event.is_action_pressed("place_building"):
		get_tree().set_input_as_handled()
		
		var place_free: bool = true
		
		for dummy in _current_dummies:
			place_free = place_free and dummy.place_free()
		
		if place_free:
			_objects_layer.add_child(_current_structure)
			_current_structure.global_position = _current_dummies.front().get_building_position()
			
			_current_structure = GameClasses.spawn_class_with_name(_current_structure.type)
	elif event.is_action_pressed("place_building_cancel"):
		get_tree().set_input_as_handled()
		
		_delete_blue_print()




func place_building_2(structure: Node2D) -> void:
	_current_structure = structure
	
	var new_collision_shapes: Array = [ ]
	var new_sprites: Array = [ ]
	var new_structures: Array = [_current_structure]#.get_children()
	
	_current_dummies = [ ]
	
	for i in range(new_structures.size()):
		new_collision_shapes.append(new_structures[i]._get_copy_of_collision_shape())
		new_sprites.append(new_structures[i]._get_copy_sprite())
		
		var new_dummy: PlacementDummy = PlacementDummy.new(new_collision_shapes[i], new_structures[i].position, new_sprites[i], new_structures[i].position)
		
		_current_dummies.append(new_dummy)
		_objects_layer.add_child(new_dummy)



func set_objects_layer(new_objects_layer: ObjectsLayer):
	_objects_layer = new_objects_layer



func _delete_blue_print() -> void:
	for dummy in _current_dummies:
		dummy.queue_free()
	
	_current_dummies = [ ]
	
	if _current_structure:
		_current_structure.queue_free()
		_current_structure = null
