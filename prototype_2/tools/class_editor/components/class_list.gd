class_name ClassList
extends Tree
tool


const SCENE := "scene"
const TYPE := "type"
const SPRITE := "sprite"
const PROPERTIES := "properties"


export(String, FILE, "*.tscn") var _packed_scene


var icon_size := 32

var _root: TreeItem
var _meta_data: Dictionary
var _column_titles: Array = [ ]




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_column_titles_visible(true)
	update_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func update_list() -> void:
	if _packed_scene.length() == 0:
		return
	
	clear()
	_root = create_item()
	
	var updated_columns := false
	var game_classes: Array = GameClasses.CLASSES[_packed_scene]
	
	for name_of_class in game_classes:
		var new_item: TreeItem = create_item(_root)
		var i := 0
		
		_meta_data = GameClasses.get_script_constant_map()[name_of_class].get_script_constant_map()
		
		for constant_name in _meta_data.keys():
			var constant = _meta_data[constant_name]
			
			if typeof(constant) == TYPE_ARRAY or typeof(constant) == TYPE_DICTIONARY:
				print(constant)
				continue
			
			var editable := true
			
			if not updated_columns:
				_column_titles.append(constant_name.to_lower())
				set_column_title(i, constant_name.capitalize())
			
			match typeof(constant):
				TYPE_STRING:
					var directory = Directory.new();
					new_item.set_cell_mode(i, TreeItem.CELL_MODE_STRING)
					
					if directory.file_exists(constant):
						new_item.set_icon(i, load(constant))
						new_item.set_icon_max_width(i, icon_size)
						editable = false
					else:
						new_item.set_text(i, constant)
				TYPE_INT:
					new_item.set_cell_mode(i, TreeItem.CELL_MODE_RANGE)
					new_item.set_range(i, constant)
			
			new_item.set_metadata(i, constant)
			new_item.set_editable(i, editable)
			
			i += 1
		
		updated_columns = true
		print(_meta_data)
	
	columns = _column_titles.size()



func add_class():
	var new_item: TreeItem = create_item(_root)
	
	for i in range(columns):
		new_item.set_editable(i, true)



func get_class_interfaces() -> Array:
	var class_interfaces: Array = [ ]
	var item: TreeItem = _root.get_children()
	
	while item:
		var prop_dict := { PROPERTIES: { } }
		
		for i in range(_column_titles.size()):
			var tit: String = _column_titles[i]
			
			if tit == SCENE:
				prop_dict[tit] = _packed_scene
			elif tit == TYPE or tit == SPRITE:
				prop_dict[tit] = item.get_metadata(i)
			else:
				prop_dict[PROPERTIES][tit] = item.get_metadata(i)
		
		var new_interface := GameClassFactory.ClassToStringInterface.new(prop_dict[SCENE], prop_dict[TYPE], prop_dict[SPRITE], prop_dict[PROPERTIES])
		class_interfaces.append(new_interface)
		
		item = item.get_next()
	
	return class_interfaces



func _get_configuration_warning() -> String:
	if _packed_scene.length() == 0:
		return "Specify a PackedScene path"
	
	return ""
