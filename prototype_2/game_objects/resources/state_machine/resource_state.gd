class_name ResourceState, "res://class_icons/game_actors/states/icon_state_idle.svg"
extends ObjectState




func drop_item(objects_layer: YSort, position_to_drop: Vector2) -> void:
	if game_object.get_parent():
		game_object.get_parent().remove_child(game_object)
	
	objects_layer.call_deferred("add_child", game_object)
	
	game_object.global_position = position_to_drop
	
	exit(IDLE)


func pick_up_item(new_inventory: Inventory) -> void:
	exit(INACTIVE)
	
	game_object.position = Vector2()
	game_object.get_parent().remove_child(game_object)
	new_inventory.call_deferred("_add_item", game_object)


func transfer_item(new_inventory: Inventory) -> void:
	game_object.get_parent().remove_child(game_object)
	new_inventory.call_deferred("_add_item", game_object)



func _toggle_active_state(object: Node, new_state: bool) -> void:
	object.appear(new_state)
	object.enable_collision(new_state)
	
	object.set_process(new_state)
	object.set_physics_process(new_state)
