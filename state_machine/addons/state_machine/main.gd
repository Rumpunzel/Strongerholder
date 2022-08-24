tool
extends EditorPlugin

var editor := preload("res://addons/state_machine/editor.tscn").instance()


func _enter_tree():
	get_editor_interface().get_editor_viewport().add_child(editor)
	make_visible(false)

func _exit_tree():
	if editor:
		editor.queue_free()


func make_visible(visible: bool) -> void:
	if not editor:
		return
	
	editor.visible = visible


func has_main_screen() -> bool:
	return true

func get_plugin_name() -> String:
	return "State Machine"

func get_plugin_icon() -> Texture:
	return get_editor_interface().get_base_control().get_icon("Spatial", "EditorIcons")
