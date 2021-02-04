class_name ClassEditor
extends PanelContainer


onready var _main_node: Main = get_tree().current_scene as Main




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func _save(quit_after: bool = false) -> void:
	print("saving")
	
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
