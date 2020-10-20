class_name ResourceState
extends ObjectState



func drop_item(objects_layer: YSort, position_to_drop: Vector2):
	_game_object.get_parent().remove_child(_game_object)
	objects_layer.call_deferred("add_child", _game_object)
	
	_game_object.global_position = position_to_drop
	
	exit(IDLE)


func pick_up_item(new_inventory: Inventory):
	exit(INACTIVE)
	
	_game_object.position = Vector2()
	_game_object.get_parent().remove_child(_game_object)
	new_inventory.call_deferred("_add_item", _game_object)
