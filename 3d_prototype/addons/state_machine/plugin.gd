extends EditorPlugin
tool

var _transition_table_inspector := preload("res://addons/state_machine/inspector/transition_table_inspector_plugin.gd").new()
var _new_transition_table_inspector := preload("res://addons/state_machine/new_inspector/transition_table_inspector_plugin.gd").new()


func _enter_tree():
	add_inspector_plugin(_transition_table_inspector)
	add_inspector_plugin(_new_transition_table_inspector)

func _exit_tree():
	remove_inspector_plugin(_transition_table_inspector)
	remove_inspector_plugin(_new_transition_table_inspector)
