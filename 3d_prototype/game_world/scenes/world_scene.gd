class_name WorldScene, "res://editor_tools/class_icons/spatials/icon_treasure_map.svg"
extends Navigation

export(Resource) var _node_spawned_channel
export(Resource) var _building_placed_channel
export(Resource) var _scene_unloaded_channel

export(AudioStream) var scene_atmosphere: AudioStream = null
export(Resource) var _scene_atmosphere_started_channel

# warning-ignore:unused_class_variable
var spotted_items := SpottedItems.new(self)


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
	_scene_atmosphere_started_channel.raise(scene_atmosphere)


func save_to_var(save_file: File) -> void:
	spotted_items.save_to_var(save_file)

func load_from_var(save_file: File) -> void:
	spotted_items.load_from_var(save_file)


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
