class_name Inventory, "res://class_icons/game_objects/icon_inventory.svg"
extends Node2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := [ "name", "_first_time" ]
const PERSIST_OBJ_PROPERTIES := [ "_starting_items" ]


signal received_item(item)


var _first_time: bool = true


export(Array, PackedScene) var _starting_items




func _ready() -> void:
	if not _first_time:
		return
	
	_first_time = false
	
	for item in _starting_items:
		var new_item: GameResource = item.instance()
		
		add_child(new_item)




func pick_up_item(item: GameResource) -> void:
	if item.pick_up_item():
		item.position = Vector2()
		item.get_parent().remove_child(item)
		
		_add_item(item)


func transfer_item(item: GameResource) -> void:
	if item.transfer_item():
		var parent: Node2D = item.get_parent()
		
		if parent:
			parent.remove_child(item)
		
		_add_item(item)



func drop_all_items(position_to_drop: Vector2) -> void:
	while get_child_count() > 0:
		drop_item(get_child(0), position_to_drop)


func drop_item(item: GameResource, position_to_drop: Vector2) -> bool:
	if get_children().has(item):
		item.drop_item(position_to_drop)
		return true
	
	return false



func empty() -> bool:
	return get_child_count() == 0


func has(object_type: String) -> GameResource:
	for item in get_children():
		if item.type == object_type:
			return item
	
	return null


func get_contents() -> Array:
	return get_children()


func capacity_left() -> float:
	var carry_weight: float = 1.0
	
	for item in get_contents():
		if not item.can_carry == 0:
			carry_weight -= 1.0 / float(item.can_carry)
	
	return carry_weight



func _add_item(item: GameResource) -> void:
	add_child(item)
	emit_signal("received_item", item)
