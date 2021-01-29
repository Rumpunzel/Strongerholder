class_name ResourceState, "res://assets/icons/game_actors/states/icon_state_idle.svg"
extends ObjectState



func _ready() -> void:
	name = IDLE




func drop_item(objects_layer: YSort, position_to_drop: Vector2) -> void:
	if _game_object.get_parent():
		_game_object.get_parent().remove_child(_game_object)
	
	objects_layer.call_deferred("add_child", _game_object)
	
	_game_object.global_position = position_to_drop
	
	exit(IDLE)


func pick_up_item(new_inventory: Inventory) -> void:
	exit(INACTIVE)
	
	_game_object.position = Vector2()
	_game_object.get_parent().remove_child(_game_object)
	new_inventory.call_deferred("_add_item", _game_object)


func transfer_item(new_inventory: Inventory) -> void:
	_game_object.get_parent().remove_child(_game_object)
	new_inventory.call_deferred("_add_item", _game_object)



func _toggle_active_state(object: Node, new_state: bool) -> void:
	object.appear(new_state)
	object.enable_collision(new_state)
	
	object.set_process(new_state)
	object.set_physics_process(new_state)
