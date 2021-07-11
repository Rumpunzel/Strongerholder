class_name GameHUD
extends GUILayerBase


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.main.connect("game_started", self, "_on_game_started")

func _exit_tree() -> void:
	Events.main.disconnect("game_started", self, "_on_game_started")


func _on_game_started() -> void:
	show_menu()
