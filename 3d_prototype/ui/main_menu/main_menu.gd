class_name MainMenu
extends Control

func _enter_tree() -> void:
	var error := Events.connect("main_menu_requested", self, "_on_main_menu_requested")
	assert(error == OK)

func _exit_tree() -> void:
	Events.disconnect("main_menu_requested", self, "_on_main_menu_requested")


func _on_main_menu_requested() -> void:
	_show_menu()

func _on_new_game_pressed() -> void:
	Events.emit_signal("new_game_started")
	_hide_menu()

func _on_quit_pressed() -> void:
	Events.emit_signal("game_quit")


func _show_menu() -> void:
	visible = true

func _hide_menu() -> void:
	visible = false
