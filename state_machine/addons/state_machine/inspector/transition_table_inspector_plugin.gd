extends EditorInspectorPlugin
tool

const StateMachineGraphEditScene := preload("res://addons/state_machine/inspector/state_machine_graph_edit.tscn")


func can_handle(object: Object) -> bool:
	return object is TransitionTableResource

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	match path:
		"entry_state_resource":
			return true
		"_transitions":
			var graph_edit := StateMachineGraphEditScene.instance()
			add_custom_control(graph_edit)
			graph_edit.transition_table = object
			return true
		"_graph_offsets":
			return true
		_:
			return false
