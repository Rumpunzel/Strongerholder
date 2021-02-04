class_name ClassGrid
extends GridContainer


export(PackedScene) var _item_scene = null




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func update_list() -> void:
	if not _item_scene:
		return
	
	clear()
	
	var i := 0
	var class_items: Array = [ ]
	
	while true:
		var new_item: ClassItem = _item_scene.instance()
		
		if class_items.empty():
			class_items = GameClasses.CLASSES.get(new_item.class_scene, [ ])
		
		if i >= class_items.size():
			new_item.queue_free()
			return
		
		add_child(new_item)
		
		var item_name: String = class_items[i]
		
		var class_constants: Dictionary = GameClasses.get_script_constant_map()[item_name].get_script_constant_map()
		
		new_item.setup(class_constants.duplicate())
		
		i += 1
#		for constant_name in class_constants.keys():
#			var constant = class_constants[constant_name]
#
#			if typeof(constant) == TYPE_ARRAY or typeof(constant) == TYPE_DICTIONARY:
#				print(constant)
#				continue
#
#			var editable := true
			
#			match typeof(constant):
#				TYPE_STRING:
#					var directory = Directory.new();
#					new_item.set_cell_mode(i, TreeItem.CELL_MODE_STRING)
#
#					if directory.file_exists(constant):
#						new_item.set_icon(i, load(constant))
#						new_item.set_icon_max_width(i, icon_size)
#						editable = false
#					else:
#						new_item.set_text(i, constant)
#				TYPE_INT:
#					new_item.set_cell_mode(i, TreeItem.CELL_MODE_RANGE)
#					new_item.set_range(i, constant)
#
#			new_item.set_metadata(i, constant)
#			new_item.set_editable(i, editable)



func add_class():
	var new_item: ClassItem = _item_scene.instance()
	add_child(new_item)



#func get_class_interfaces() -> Array:
#	var class_interfaces: Array = [ ]
#	var item: TreeItem = _root.get_children()
#
#	while item:
#		var prop_dict := { PROPERTIES: { } }
#
#		for i in range(_column_titles.size()):
#			var tit: String = _column_titles[i]
#
#			if tit == SCENE:
#				prop_dict[tit] = _packed_scene
#			elif tit == TYPE or tit == SPRITE:
#				prop_dict[tit] = item.get_metadata(i)
#			else:
#				prop_dict[PROPERTIES][tit] = item.get_metadata(i)
#
#		var new_interface := GameClassFactory.ClassToStringInterface.new(prop_dict[SCENE], prop_dict[TYPE], prop_dict[SPRITE], prop_dict[PROPERTIES])
#		class_interfaces.append(new_interface)
#
#		item = item.get_next()
#
#	return class_interfaces


func clear() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
