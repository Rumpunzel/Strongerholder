extends EditorInspectorPlugin
tool

const TransitionTableEditor := preload("res://addons/state_machine/inspector/transition_table_editor.gd")
var _editor := preload("res://addons/state_machine/inspector/editor.tscn").instance()


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
		var transition_table_editor := TransitionTableEditor.new()
		add_property_editor(path, transition_table_editor)
		add_custom_control(_editor)
		var transitions: Array = object.get("_transitions")
		for resource in transitions:
			var transition: TransitionItemResource = resource
			_editor.add_transition(transition)
		return false
		return true
	else:
		return false
