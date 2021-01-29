class_name Inventory, "res://assets/icons/icon_inventory.svg"
extends Node2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name", "_first_time"]
const PERSIST_OBJ_PROPERTIES := ["_starting_items"]


signal received_item(item)


var _first_time: bool = true


export(Array, PackedScene) var _starting_items




func _ready():
	if not _first_time:
		return
	
	_first_time = false
	
	for item in _starting_items:
		var new_item: Node2D = item.instance()
		
		add_child(new_item)




func pick_up_item(item: Node2D):
	item.pick_up_item(self)

func transfer_item(item: Node2D):
	item.transfer_item(self)



func drop_all_items(position_to_drop: Vector2):
	while get_child_count() > 0:
		drop_item(get_child(0), position_to_drop)


func drop_item(item: Node2D, position_to_drop: Vector2) -> bool:
	if get_children().has(item):
		item.drop_item(position_to_drop)
		return true
	
	return false



func empty() -> bool:
	return get_child_count() == 0


func has(object_type) -> Node2D:
	for item in get_children():
		if item.type == object_type:
			return item
	
	return null


func get_contents() -> Array:
	return get_children()


func capacity_left() -> float:
	var carry_weight: float = 1.0
	
	for item in get_contents():
		if not item.how_many_can_be_carried == 0.0:
			carry_weight -= 1.0 / float(item.how_many_can_be_carried)
	
	return carry_weight



func _add_item(item: Node2D):
	add_child(item)
	emit_signal("received_item", item)
