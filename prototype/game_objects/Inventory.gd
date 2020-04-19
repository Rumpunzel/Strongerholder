class_name Inventory, "res://assets/icons/icon_inventory.svg"
extends Node


signal received_item(item)
signal sent_item(item)


export(Array, PackedScene) var _starting_inventory: Array


var contents: Array = [ ]




func _ready():
	owner.connect("activate", self, "initialize")




func initialize():
	for item in _starting_inventory:
		receive_item(item.instance(), null)


func receive_item(item: GameResource, sender):
	if item:
		contents.append(item)
		emit_signal("received_item", item)
		
		if sender:
			pass
			#print("%s gave %s: %s" % [sender.owner.name, owner.name, item.type])


func request_item(requested_item, receiver):
	if requested_item is GameResource:
		_send_item(requested_item, receiver)
	else:
		var item: GameResource = null
		
		for resource in contents:
			if resource.type == requested_item:
				item = resource
				break
		
		if item:
			_send_item(item, receiver)



func empty() -> bool:
	return contents.empty()

func has(object_type: String) -> bool:
	for item in contents:
		if item.type == object_type:
			return true
	
	return false




func _send_item(item_to_send: GameResource, receiver):
	if contents.has(item_to_send):
		contents.erase(item_to_send)
		receiver.receive_item(item_to_send, self)
		emit_signal("sent_item", item_to_send)


func _send_all_items(receiver):
	for item in contents:
		_send_item(item, receiver)
