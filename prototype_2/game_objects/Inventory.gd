class_name Inventory, "res://assets/icons/icon_inventory.svg"
extends Node2D


signal received_item(item)
signal sent_item(item)




func _ready():
	owner.connect("activate", self, "initialize")
	owner.connect("died", self, "drop_all_items")




func initialize():
	for item in get_children():
		receive_item(item, null)


func receive_item(item: GameResource, sender):
	item.pick_up_item(self)
	emit_signal("received_item", item)
	
	if sender:
		pass
		#print("%s gave %s: %s" % [sender.owner.name, owner.name, item.type])


func request_item(requested_item, receiver):
	if requested_item is GameResource:
		_send_item(requested_item, receiver)
	else:
		var item: GameResource = null
		
		for resource in get_children():
			if resource is GameResource and resource.type == requested_item:
				item = resource
				break
		
		if item:
			_send_item(item, receiver)


func drop_all_items():
	while get_child_count() > 0:
		drop_item(get_child(0))


func drop_item(item: GameResource):
	item.drop_item()



func empty() -> bool:
	return get_child_count() == 0


func has(object_type: String) -> bool:
	for item in get_children():
		if item.type == object_type:
			return true
	
	return false


func get_contents() -> Array:
	var contents: Array = [ ]
	
	for item in get_children():
		contents.append(item.type)
	
	return contents




func _send_item(item_to_send: GameResource, receiver):
	if get_children().has(item_to_send):
		item_to_send.deactivate_object()
		receiver.receive_item(item_to_send, self)
		emit_signal("sent_item", item_to_send)
