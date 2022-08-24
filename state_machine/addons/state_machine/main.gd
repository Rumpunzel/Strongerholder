extends EditorPlugin
tool

var _transition_table_inspector := preload("res://addons/state_machine/transition_table_inspector_plugin.gd").new()


func _enter_tree():
	add_inspector_plugin(_transition_table_inspector)

func _exit_tree():
	remove_inspector_plugin(_transition_table_inspector)
