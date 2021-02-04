class_name ClassEditor
extends PanelContainer


onready var _main_node: Main = get_tree().current_scene as Main
onready var _classes: TabContainer = $MarginContainer/TopDivider/EditorDivider/Classes




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func _save(quit_after: bool = false) -> void:
	print("saving")
	
	var class_interfaces := { }
	
	for game_class in _classes.get_children():
		var dict: Dictionary = game_class.get_class_interfaces()
		for key in dict.keys():
			class_interfaces[key] = dict[key]
	
	#print(class_interfaces)
	GameClassFactory.create_file(class_interfaces)
	
	if quit_after:
		_leave_editor()


func _quit(with_saving: bool = true) -> void:
	if with_saving:
		_save(true)
	else:
		_leave_editor()


func _leave_editor() -> void:
	_main_node.open_main_menu()
	
	get_parent().remove_child(self)
	queue_free()
