class_name BuildMenu
extends Control


var _current_dummies: Array = [ ]
var _current_blueprint: PackedScene = null
var _current_structure: BuildingPoint = null


onready var _objects_layer: ObjectsLayer = ServiceLocator.objects_layer
onready var _popup: Popup = $popup




func _gui_input(event: InputEvent) -> void:
	if _current_dummies.empty():
		return
	
	if event.is_action_pressed("place_building"):
		get_tree().set_input_as_handled()
		
		var place_free: bool = true
		
		for dummy in _current_dummies:
			place_free = place_free and dummy.place_free()
		
		if place_free:
			_objects_layer.add_child(_current_structure)
			_current_structure.global_position = _current_dummies.front().global_position
			
			_current_structure = _current_blueprint.instance()
	elif event.is_action_pressed("place_building_cancel"):
		get_tree().set_input_as_handled()
		
		_delete_blue_print()




func place_building(structure: PackedScene) -> void:
	_close()
	
	_current_blueprint = structure
	_current_structure = _current_blueprint.instance()
	
	var new_collision_shapes: Array = [ ]
	var new_sprites: Array = [ ]
	var new_structures: Array = _current_structure.get_children()
	
	_current_dummies = [ ]
	
	for i in range(new_structures.size()):
		new_collision_shapes.append(new_structures[i]._get_copy_of_collision_shape())
		new_sprites.append(new_structures[i]._get_copy_sprite())
		
		var new_dummy: PlacementDummy = PlacementDummy.new(new_collision_shapes[i], new_structures[i].position, new_sprites[i], new_structures[i].position)
		
		_current_dummies.append(new_dummy)
		_objects_layer.add_child(new_dummy)



func _open_build_menu() -> void:
	_delete_blue_print()
	
	_popup.show()


func _close() -> void:
	_popup.hide()



func _delete_blue_print() -> void:
	for dummy in _current_dummies:
		dummy.queue_free()
	
	_current_dummies = [ ]
	
	_current_blueprint = null
	
	if _current_structure:
		_current_structure.queue_free()
		_current_structure = null
