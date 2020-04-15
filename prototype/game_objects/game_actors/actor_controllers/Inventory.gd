class_name Inventory, "res://assets/icons/icon_inventory.svg"
extends Node


signal received_item(item)
signal sent_item(item)


export(Array, Constants.Resources) var starting_inventory: Array

export var start_active: bool = true


var contents: Array setget , get_contents




func _ready():
	if start_active:
		initialize()




func receive_item(item, sender):
	if item:
		contents.append(item)
		emit_signal("received_item", item)
		
		if sender:
			print("%s gave %s: %s" % [sender.owner.name, owner.name, Constants.enum_name(Constants.Resources, item)])


func send_item(item_to_send, receiver):
	if contents.has(item_to_send):
		contents.erase(item_to_send)
		receiver.receive_item(item_to_send, self)
		emit_signal("sent_item", item_to_send)


func send_all_items(receiver):
	for item in contents:
		send_item(item, receiver)


func initialize():
	for item in starting_inventory:
		receive_item(item, null)


func empty() -> bool:
	return contents.empty()

func has(object) -> bool:
	return contents.has(object)


func get_contents() -> Array:
	return contents
