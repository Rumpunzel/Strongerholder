extends EditorInspectorPlugin
tool

const StateMachineGraphEditScene := preload("res://addons/state_machine/new_inspector/state_machine_graph_edit.tscn")


func can_handle(object: Object) -> bool:
	return object is StateMachine2

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	match path:
		"entry_state":
			return true
		"_transitions":
			var graph_edit := StateMachineGraphEditScene.instance()
			add_custom_control(graph_edit)
			graph_edit.state_machine = object
			return true
		"_graph_offsets":
			return true
		_:
			return false
