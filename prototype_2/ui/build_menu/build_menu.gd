class_name BuildMenu
extends Control


var _current_dummy: PlacementDummy = null
var _current_blueprint: PackedScene = null
var _current_structure: Structure = null


onready var _objects_layer: ObjectsLayer = ServiceLocator.objects_layer
onready var _popup: Popup = $popup




func _gui_input(event: InputEvent):
	if _current_dummy:
		if event.is_action_pressed("place_building"):
			get_tree().set_input_as_handled()
			
			if _current_dummy.place_free():
				_objects_layer.add_child(_current_structure)
				_current_structure.global_position = _current_dummy.global_position
				
				_current_structure = _current_blueprint.instance()
			
		elif event.is_action_pressed("place_building_cancel"):
			get_tree().set_input_as_handled()
			
			_current_dummy.queue_free()
			_current_dummy = null
			
			_current_blueprint = null
			
			_current_structure.queue_free()
			_current_structure = null




func place_building(structure: PackedScene):
	_close()
	
	_current_blueprint = structure
	_current_structure = _current_blueprint.instance()
	
	var new_collision_shape: CollisionShape2D = _current_structure._get_copy_of_collision_shape()
	var new_sprite: Sprite = _current_structure._get_copy_sprite()
	
	_current_dummy = PlacementDummy.new(new_collision_shape, new_sprite)
	_objects_layer.add_child(_current_dummy)



func _open_build_menu():
	_popup.show()


func _close():
	_popup.hide()
