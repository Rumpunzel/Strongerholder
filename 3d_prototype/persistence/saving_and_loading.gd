class_name SavingAndLoading
extends Node


const SAVE_LOCATION := "res://test.save"#"user://savegame.save"
const PERSIST_GROUP := "Persist"
const PERSIST_DATA_GROUP := "PersistData"
const OBJECT_TERMINATOR := "|"
const CHILDREN_BEGIN := "<"
const CHILDREN_END := ">"


export(String, FILE, "*.tscn") var _default_scene



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.main.connect("game_save_started", self, "_on_game_save_started")
	# warning-ignore:return_value_discarded
	Events.main.connect("game_load_started", self, "_on_game_load_started")

func _exit_tree() -> void:
	Events.main.disconnect("game_save_started", self, "_on_game_save_started")
	Events.main.disconnect("game_load_started", self, "_on_game_load_started")



func _on_game_save_started() -> void:
	var save_file := File.new()
	var error := save_file.open(SAVE_LOCATION, File.WRITE)
	assert(error == OK)
	
	var nodes_to_save := get_tree().get_nodes_in_group(PERSIST_GROUP)
	
	_store_version(save_file)
	_store_data(nodes_to_save, save_file, true)
	
	save_file.close()
	Events.main.emit_signal("game_save_finished")


func _on_game_load_started(start_new_game := false) -> void:
	var save_nodes := get_tree().get_nodes_in_group(PERSIST_GROUP)
	for node in save_nodes:
		node.get_parent().remove_child(node)
		node.queue_free()
	
	var save_file := File.new()
	if not start_new_game and save_file.file_exists(SAVE_LOCATION):
		var error := save_file.open(SAVE_LOCATION, File.READ)
		assert(error == OK)
		
		_load_version(save_file)
		_load_data(save_file)
		
		print("Game loaded from %s" % SAVE_LOCATION)
	else:
		var packed_scene: PackedScene = load(_default_scene)
		assert(packed_scene)
		var scene: WorldScene = packed_scene.instance()
		Events.gameplay.emit_signal("scene_loaded", scene)
		
		Events.gameplay.emit_signal("new_game")
	
	save_file.close()
	Events.main.emit_signal("game_load_finished")


func _store_data(nodes_to_save: Array, save_file: File, on_scene_layer := false) -> void:
	for node in nodes_to_save:
		# Check the node is an instanced scene so it can be instanced again during load.
		if on_scene_layer:
			if node.filename.empty():
				printerr("persistent node '%s' is not an instanced scene, skipped" % node.name)
				continue
			
			_store_scene_data(node, save_file)
		else:
			save_file.store_var(node.owner.get_path_to(node))
		
		# Check the node has a save function.
		if node.has_method("save_to_var"):
			# Call the node's save function.
			node.call("save_to_var", save_file)
		else:
			print("persistent node '%s' is missing a save() function, only essentials will be saved" % node.name)
		
		
		var children_to_save := _get_children_in_group(node, PERSIST_DATA_GROUP, PERSIST_GROUP)
		if not children_to_save.empty():
			save_file.store_var(CHILDREN_BEGIN)
			_store_data(children_to_save, save_file)
			save_file.store_var(CHILDREN_END)
		elif on_scene_layer:
			save_file.store_var(OBJECT_TERMINATOR)

func _store_scene_data(node: Node, save_file: File) -> void:
	save_file.store_var(node.get_filename())
	save_file.store_var(node.get_parent().get_path())
	if node is Spatial:
		save_file.store_var((node as Spatial).transform)


func _load_data(save_file: File) -> void:
	var length := save_file.get_len()
	while save_file.get_position() < length:
		_load_next_scene(save_file.get_var(), save_file)

func _load_next_scene(scene_path: String, save_file: File) -> void:
	assert(save_file.file_exists(scene_path))
	
	var scene: PackedScene = load(scene_path)
	var node: Node = scene.instance()
	var path_of_parent: String = save_file.get_var()
	if node is Spatial:
		var transform: Transform = save_file.get_var()
		(node as Spatial).transform = transform
	
	if node.has_method("save_to_var"):
		assert(node.has_method("load_from_var"))
		node.call("load_from_var", save_file)
	
	var next_var = save_file.get_var()
	if  next_var is String and next_var == CHILDREN_BEGIN:
		_load_children(node, save_file)
	
	get_node(path_of_parent).add_child(node)

func _load_children(node: Node, save_file: File) -> void:
	var next_var = save_file.get_var()
	while not (next_var is String and next_var == CHILDREN_END):
		_load_next_child(node, next_var, save_file)
		next_var = save_file.get_var()

func _load_next_child(node: Node, node_path: String, save_file: File) -> void:
	var child_node := node.get_node_or_null(node_path)
	assert(child_node)
	assert(child_node.has_method("load_from_var"))
	child_node.call("load_from_var", save_file)


func _store_version(save_file: File) -> void:
	save_file.store_var(GameVersion.major_version())
	save_file.store_var(GameVersion.minor_version())
	save_file.store_var(GameVersion.patch_version())

func _load_version(save_file: File) -> void:
	var major: int = save_file.get_var()
	var minor: int = save_file.get_var()
	var patch: int = save_file.get_var()
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
		
		if child.is_in_group(PERSIST_DATA_GROUP):
			children_in_group.append(child)
		
		children_in_group += _get_children_in_group(child, group, terminate_on_group)
	
	return children_in_group
