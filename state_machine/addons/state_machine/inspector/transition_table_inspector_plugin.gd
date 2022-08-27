extends EditorInspectorPlugin
tool

const TransitionTableEditorButton := preload("res://addons/state_machine/inspector/transition_table_editor_button.gd")
const StateMachineGraphEditScene := preload("res://addons/state_machine/inspector/state_machine_graph_edit.tscn")


func can_handle(object: Object) -> bool:
	return object is TransitionTableResource

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if path == "_transitions":
		#var button := TransitionTableEditorButton.new()
		var graph_edit := StateMachineGraphEditScene.instance()
		
		#button.toggle_button.pressed = object is TransitionTableResource
		#graph_edit.visible = object is TransitionTableResource
		#button.connect("property_updated", graph_edit, "_on_transitions_updated" )
		#button.toggle_button.connect("toggled", graph_edit, "set_visible")
		#add_property_editor(path, button)
		add_custom_control(graph_edit)
		graph_edit.transition_table = object
		
		return false
	else:
		return false
