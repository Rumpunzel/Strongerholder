class_name SpottedItems
extends Node

# The format of this is as follows:
#	Dictionary of ItemResources: {
#		to a Dictionary of spotted Nodes: {
#			to an Array of InteractionAreas who spotted the Node [ spotter_1, spotter_2 ]
#		}
#	}
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
					elif not weakref(item_spotter).get_ref():
						spotted[item].erase(item_spotter)
		else:
			# warning-ignore:return_value_discarded
			spotted.erase(item)
	
	return return_array


func save_to_var(save_file: File) -> void:
	for spotted_nodes in _spotted_items.values():
		for node in spotted_nodes.keys():
			if not weakref(node).get_ref() or not node.is_inside_tree():
				spotted_nodes.erase(node)
	
	save_file.store_16(_spotted_items.size())
	for item_key in _spotted_items.keys():
		var item: ItemResource = item_key
		save_file.store_var(item.resource_path)
		
		var spotted_nodes: Dictionary = _spotted_items[item]
		save_file.store_16(spotted_nodes.size())
		for node_key in spotted_nodes.keys():
			var node: CollectableItem = node_key
			save_file.store_var(node.get_path())
			
			var spotters: Array = spotted_nodes[node]
			save_file.store_16(spotters.size())
			for spotter_element in spotters:
				var spotter: Node = spotter_element
				save_file.store_var(spotter.get_path())

# TODO: unit test this at some point
func load_from_var(save_file: File) -> void:
	var spotted_items_size := save_file.get_16()
	for _spotted_item_index in range(spotted_items_size):
		var item_path: String = save_file.get_var()
		var item: ItemResource = load(item_path)
		_spotted_items[item] = { }
		
		var spotted_nodes_size := save_file.get_16()
		for _spotted_node_index in range(spotted_nodes_size):
			var node_path: String = save_file.get_var()
			var node: Node = get_node(node_path)
			
			var spotters_size := save_file.get_16()
			var spotters := [ ]
			for _spotter_index in range(spotters_size):
				var spotter_path: String = save_file.get_var()
				var spotter: Node = get_node(spotter_path)
				spotters.append(spotter)
			
			_spotted_items[item][node] = spotters



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
