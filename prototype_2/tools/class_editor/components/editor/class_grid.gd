class_name ClassGrid
extends GridContainer

# warning-ignore-all:unsafe_property_access

const _PROPERTIES := "_PROPERTIES"


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
	var lookup_file: GDScript = load("res://game_objects/game_classes.gd")
	var game_classes: Dictionary = lookup_file.get_script_constant_map()
	
	while true:
		var new_item: ClassItem = _item_scene.instance()
		
		if class_items.empty():
			class_items = lookup_file.CLASSES.get(new_item.class_scene, [ ])
		
		if i >= class_items.size():
			new_item.queue_free()
			return
		
		add_child(new_item)
		
		var item_name: String = class_items[i]
		var class_constants: Dictionary = game_classes[item_name].get_script_constant_map()
		
		new_item.setup(class_constants.duplicate())
		
		i += 1



func add_class():
	var new_item: ClassItem = _item_scene.instance()
	add_child(new_item)



func get_class_interfaces() -> Dictionary:
	var class_interfaces: Dictionary = { }
	
	if not _item_scene:
		return class_interfaces
	
	var new_item: ClassItem = _item_scene.instance()
	var class_scene: String = new_item.class_scene
	
	class_interfaces[class_scene] = [ ]
	new_item.queue_free()
	
	for item in get_children():
		class_interfaces[class_scene].append(item.get_class_interface())
	
	return class_interfaces


func clear() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
