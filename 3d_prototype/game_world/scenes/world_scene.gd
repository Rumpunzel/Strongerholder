class_name WorldScene, "res://editor_tools/class_icons/spatials/icon_treasure_map.svg"
extends Navigation


export(Resource) var _node_spawned_channel
export(Resource) var _building_placed_channel
export(Resource) var _scene_unloaded_channel

export(AudioStream) var scene_atmosphere: AudioStream = null
export(Resource) var _scene_atmosphere_started_channel


var _spotted_items := { }



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_node_spawned_channel.connect("raised", self, "_on_node_spawned")
	# warning-ignore:return_value_discarded
	_building_placed_channel.connect("raised", self, "_on_building_placed")

func _exit_tree() -> void:
	_node_spawned_channel.disconnect("raised", self, "_on_node_spawned")
	_building_placed_channel.disconnect("raised", self, "_on_building_placed")
	
	_scene_unloaded_channel.raise(self)


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	_scene_atmosphere_started_channel.raise(scene_atmosphere)



func get_spotted(item: ItemResource) -> Array:
	var return_array := [ ]
	var spotted: Array = _spotted_items.get(item, [ ])
	
	for item in spotted:
		if weakref(item).get_ref():
			return_array.append(item)
		else:
			spotted.erase(item)
	
	return return_array



func _on_node_spawned(node: Spatial, position: Vector3, random_rotation: bool) -> void:
	add_child(node, true)
	node.translation = position
	
	if random_rotation:
		node.rotate_x(randf() * TAU)
		node.rotate_y(randf() * TAU)
		node.rotate_z(randf() * TAU)

func _on_building_placed(structure: Structure, position: Vector3, y_rotation: float) -> void:
	add_child(structure, true)
	structure.translation = position
	structure.rotate_y(y_rotation)


func _on_item_spotted(item: CollectableItem) -> void:
	if not item is CollectableItem or not item.is_inside_tree():
		return
	
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	var item_resource: ItemResource = item.item_resource
	_spotted_items[item_resource] = _spotted_items.get(item_resource, [ ])
	
	var items_of_type: Array = _spotted_items[item_resource]
	if not items_of_type.has(item):
		items_of_type.append(item)
		_spotted_items[item_resource] = items_of_type

func _on_item_picked_up(item: CollectableItem) -> void:
	if not item is CollectableItem:
		return
	
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	var item_resource: ItemResource = item.item_resource
	var items_of_type: Array = _spotted_items.get(item_resource, [ ])
	if items_of_type.has(item):
		items_of_type.erase(item)
		_spotted_items[item_resource] = items_of_type
