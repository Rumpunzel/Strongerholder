class_name SpottedItems
extends Resource

var _spotted_items := { }


func get_spotted(item: ItemResource, spotter: Node) -> Array:
	var return_array := [ ]
	var spotted: Dictionary = _spotted_items.get(item, { })
	
	for item in spotted.keys():
		if weakref(item).get_ref():
			if spotted[item].empty():
				return_array.append(item)
			else:
				for item_spotter in spotted[item]:
					if item_spotter == spotter:
						return_array.append(item)
						break
		else:
			# warning-ignore:return_value_discarded
			spotted.erase(item)
	
	return return_array



func _on_item_spotted(item: CollectableItem, spotter: Node) -> void:
	if not item is CollectableItem:
		return
	
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	var item_resource: ItemResource = item.item_resource
	var spotters: Array = _spotted_items[item_resource].get(item, [ ])
	
	spotters.erase(spotter)
	_spotted_items[item_resource][item] = spotters


func _on_item_approached(item: CollectableItem, spotter: Node) -> void:
	if not item is CollectableItem:
		return
	
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	var item_resource: ItemResource = item.item_resource
	_spotted_items[item_resource] = _spotted_items.get(item_resource, { })
	_spotted_items[item_resource][item] = _spotted_items[item_resource].get(item, [ ])
	
	var spotters: Array = _spotted_items[item_resource][item]
	if not spotters.has(spotter):
		spotters.append(spotter)
		_spotted_items[item_resource][item] = spotters


func _on_item_picked_up(item: CollectableItem) -> void:
	if not item is CollectableItem:
		return
	
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	var item_resource: ItemResource = item.item_resource
	var items_of_type: Dictionary = _spotted_items.get(item_resource, { })
	
	# warning-ignore:return_value_discarded
	items_of_type.erase(item)
	_spotted_items[item_resource] = items_of_type
