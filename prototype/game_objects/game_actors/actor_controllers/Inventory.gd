class_name Inventory, "res://assets/icons/icon_inventory.svg"
extends Node


signal received_item(item)
signal sent_item(item)


export(Array, Constants.Resources) var starting_inventory: Array


var contents: Array setget , get_contents




func _ready():
	initialize()




func receive_item(item, sender):
	var new_item = sender.send_item(item, self) if sender else item
	
	if new_item:
		contents.append(new_item)
		emit_signal("received_item", item)
		
		if sender:
			print("%s gave %s: %s" % [sender.name, name, Constants.enum_name(Constants.Resources, new_item)])


func send_item(item_to_send, _sender):
	if contents.has(item_to_send):
		contents.erase(item_to_send)
		emit_signal("sent_item", item_to_send)
		
		return item_to_send
	else:
		return null


func initialize():
	for item in starting_inventory:
		receive_item(item, null)


func empty() -> bool:
	return contents.empty()

func has(object) -> bool:
	return contents.has(object)


func get_contents() -> Array:
	return contents
