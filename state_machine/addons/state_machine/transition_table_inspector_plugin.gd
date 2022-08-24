extends EditorInspectorPlugin

var _transition_table_editor := preload("res://addons/state_machine/transition_table_editor.gd")
var _editor := preload("res://addons/state_machine/editor.tscn").instance()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func can_handle(object: Object) -> bool:
	return object is TransitionTableResource

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if path == "_transitions":
		add_property_editor(path, _transition_table_editor.new())
		add_custom_control(_editor)
		return false
		return true
	else:
		return false
