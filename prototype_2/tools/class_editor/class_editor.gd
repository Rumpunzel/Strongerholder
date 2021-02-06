class_name ClassEditor
extends PanelContainer


var _game_class_factory := GameClassFactory.new()
var _going_to_save := { "saving": false, "quit_after": false, "busy": false }
var _every_n_frames := 50
var _frames_passed := 0


onready var _main_node: Main = get_tree().current_scene as Main
onready var _classes: TabContainer = $MarginContainer/TopDivider/EditorDivider/Classes




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _going_to_save["busy"] and _going_to_save["saving"]:
		if _frames_passed >= _every_n_frames:
			_frames_passed = 0
			_actually_save(_going_to_save["quit_after"])
		else:
			print("CURRENTLY BUSY // FILE WAS NOT SAVED!")
	
	_frames_passed += 1




func _save(quit_after: bool = false) -> void:
	_going_to_save = { "saving": true, "quit_after": quit_after, "busy": false }


func _actually_save(quit_after: bool = false) -> void:
	_going_to_save["busy"] = true
	print("saving")
	
	var class_interfaces := { }
	
	for game_class in _classes.get_children():
		var dict: Dictionary = game_class.get_class_interfaces()
		for key in dict.keys():
			class_interfaces[key] = dict[key]
	
	#print(class_interfaces)
	_game_class_factory.create_file(class_interfaces)
	#yield(_game_class_factory, "file_created")
	yield(get_tree(), "idle_frame")
	
	
	print("successfully saved")
	_going_to_save = { "saving": false, "quit_after": false, "busy": false }
	
	if quit_after:
		_leave_editor()


func _quit() -> void:
	_save(true)


func _leave_editor() -> void:
	_main_node.quit_game()
#	_main_node.open_main_menu()
#
#	get_parent().remove_child(self)
#	queue_free()
