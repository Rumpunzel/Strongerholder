class_name GameHUD
extends GUILayerBase


func _enter_tree() -> void:
	var error := Events.connect("game_started", self, "_on_game_started")
	assert(error == OK)

func _exit_tree() -> void:
	Events.disconnect("game_started", self, "_on_game_started")


func _on_game_started() -> void:
	show_menu()
