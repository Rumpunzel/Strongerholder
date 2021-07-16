class_name SavingAndLoading, "res://editor_tools/class_icons/nodes/icon_save.svg"
extends Node

const SAVE_LOCATION := "res://test.save"#"user://savegame.save"
const PERSIST_LEVEL := "PersistLevel"
const PERSIST_GROUP := "Persist"
const PERSIST_DATA_GROUP := "PersistData"
const SEPARATOR := "|"

export(String, FILE, "*.tscn") var _default_scene

export(Resource) var _game_save_started_channel
export(Resource) var _game_save_finished_channel

export(Resource) var _game_load_started_channel
export(Resource) var _game_load_finished_channel

export(Resource) var _scene_loaded_channel
export(Resource) var _new_game_channel



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_game_save_started_channel.connect("raised", self, "_on_game_save_started")
	# warning-ignore:return_value_discarded
	_game_load_started_channel.connect("raised", self, "_on_game_load_started")

func _exit_tree() -> void:
	_game_save_started_channel.disconnect("raised", self, "_on_game_save_started")
	_game_load_started_channel.disconnect("raised", self, "_on_game_load_started")



func _on_game_save_started() -> void:
	var save_file := File.new()
	var error := save_file.open(SAVE_LOCATION, File.WRITE)
	assert(error == OK)
	
	_store_version(save_file)
	
	var nodes_to_save := [ ]
	var child_nodes_to_save := { }
	
	# Store level structure
	nodes_to_save = get_tree().get_nodes_in_group(PERSIST_LEVEL)
	_store_persist(nodes_to_save, save_file, child_nodes_to_save)
	
	save_file.store_var(SEPARATOR)
	
	# Store object structure
	nodes_to_save = get_tree().get_nodes_in_group(PERSIST_GROUP)
	_store_persist(nodes_to_save, save_file, child_nodes_to_save)
	
	save_file.store_var(SEPARATOR)
	
	# Store data
	_store_data(child_nodes_to_save, save_file)
	
	save_file.close()
	_game_save_finished_channel.raise()


func _on_game_load_started(start_new_game: bool) -> void:
	var save_file := File.new()
	
	if save_file.file_exists(SAVE_LOCATION) or start_new_game:
		# Delete the current loaded persistent objects
		var save_nodes := get_tree().get_nodes_in_group(PERSIST_LEVEL)
		save_nodes += get_tree().get_nodes_in_group(PERSIST_GROUP)
		
		for node in save_nodes:
			node.get_parent().remove_child(node)
			node.queue_free()
		
		if not start_new_game:
			# Load from the save file
			var error := save_file.open(SAVE_LOCATION, File.READ)
			assert(error == OK)
			
			_load_version(save_file)
			_load_data(save_file)
			
			print("Game loaded from %s" % SAVE_LOCATION)
		
		else:
			# Load the default scene
			var packed_scene: PackedScene = load(_default_scene)
			assert(packed_scene)
			
			var scene: WorldScene = packed_scene.instance()
			_scene_loaded_channel.raise(scene)
			
			_new_game_channel.raise()
	
	else:
		# Simply start the already loaded scene
		_new_game_channel.raise()
	
	
	save_file.close()
	_game_load_finished_channel.raise()



func _store_persist(nodes_to_save: Array, save_file: File, child_nodes_to_save: Dictionary) -> void:
	for node in nodes_to_save:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			printerr("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		_store_scene_data(node, save_file)
		
		# Check the node has a save function.
		if node.has_method("save_to_var"):
			assert(node.has_method("load_from_var"))
			# Call the node's save function.
			node.call("save_to_var", save_file)
		else:
			print("persistent node '%s' is missing a save_to_var() function, only essentials will be saved" % node.name)
		
		
		var children_to_save := _get_children_in_group(node, PERSIST_DATA_GROUP, PERSIST_GROUP)
		if not children_to_save.empty():
			child_nodes_to_save[node] = children_to_save

func _store_scene_data(node: Node, save_file: File) -> void:
	save_file.store_var(node.get_filename())
	save_file.store_var(node.name)
	save_file.store_var(node.get_parent().get_path())


func _store_data(children_to_save: Dictionary, save_file: File) -> void:
	for node in children_to_save.keys():
		for child in children_to_save[node]:
			# Check the node has a save function.
			if child.has_method("save_to_var"):
				assert(child.has_method("load_from_var"))
				
				save_file.store_var(node.get_path())
				save_file.store_var(node.get_path_to(child))
				
				# Call the node's save function.
				child.call("save_to_var", save_file)
			else:
				print("persistent child node '%s' is missing a save_to_var() function, skipped" % child.name)
				continue



func _load_data(save_file: File) -> void:
	var length := save_file.get_len()
	while save_file.get_position() < length:
		var next_var = save_file.get_var()
		if next_var is String and next_var == SEPARATOR:
			break
		
		_load_next_scene(next_var, save_file, true)
	
	while save_file.get_position() < length:
		var next_var = save_file.get_var()
		if next_var is String and next_var == SEPARATOR:
			break
		
		_load_next_scene(next_var, save_file)
	
	while save_file.get_position() < length:
		var next_var = save_file.get_var()
		_load_next_child(next_var, save_file)


func _load_next_scene(scene_path: String, save_file: File, is_level := false) -> void:
	assert(save_file.file_exists(scene_path))
	
	var scene: PackedScene = load(scene_path)
	var node: Node = scene.instance()
	
	var node_name: String = save_file.get_var()
	var parent_path: String = save_file.get_var()
	
	if node.has_method("save_to_var"):
		assert(node.has_method("load_from_var"))
		node.call("load_from_var", save_file)
	
	# HACK: currently this just deletes all the persistent nodes from the level
	#	consider implementing this by instead loading a base level
	#	  with only static scenes when loading a level
	if is_level:
		for child in _get_children_in_group(node, PERSIST_GROUP, ""):
			child.get_parent().remove_child(child)
			child.queue_free()
	
	get_node(parent_path).add_child(node)
	node.name = node_name


func _load_next_child(parent_path: String, save_file: File) -> void:
	var parent_node: Node = get_node(parent_path)
	assert(parent_node)
	
	var node_path: String = save_file.get_var()
	
	var child_node := parent_node.get_node(node_path)
	assert(child_node)
	
	assert(child_node.has_method("load_from_var"))
	child_node.call("load_from_var", save_file)



func _store_version(save_file: File) -> void:
	save_file.store_16(GameVersion.major_version())
	save_file.store_16(GameVersion.minor_version())
	save_file.store_16(GameVersion.patch_version())

func _load_version(save_file: File) -> void:
	var major: int = save_file.get_16()
	var minor: int = save_file.get_16()
	var patch: int = save_file.get_16()
	print("----------GAME VERSION----------")
	print("version %d.%d.%d" % [ major, minor, patch ])
	print("--------------------------------")
	assert(major == GameVersion.major_version())
	assert(minor == GameVersion.minor_version())
	assert(patch == GameVersion.patch_version())



func _get_children_in_group(parent: Node, group: String, terminate_on_group: String) -> Array:
	var children_in_group := [ ]

	for child in parent.get_children():
		if child.is_in_group(terminate_on_group):
			continue
		
		if child.is_in_group(group):
			children_in_group.append(child)
		
		children_in_group += _get_children_in_group(child, group, terminate_on_group)
	
	return children_in_group
