extends EditorInspectorPlugin
tool

const TransitionTableEditor := preload("res://addons/state_machine/inspector/transition_table_editor.gd")
const StateMachineGraphEditScene := preload("res://addons/state_machine/inspector/state_machine_graph_edit.tscn")


func can_handle(object: Object) -> bool:
	return object is TransitionTableResource

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if path == "_transitions":
		var graph_edit := StateMachineGraphEditScene.instance()
		add_custom_control(graph_edit)
		graph_edit.transition_table = object
		#var editor := TransitionTableEditor.new(object, path, graph_edit)
		#add_property_editor(path, editor)
		return false
	else:
		return false
