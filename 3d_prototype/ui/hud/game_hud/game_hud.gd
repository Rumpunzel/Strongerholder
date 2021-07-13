class_name GameHUD
extends GUILayerBase


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.main.connect("game_paused", self, "_on_game_paused")
	# warning-ignore:return_value_discarded
	Events.main.connect("game_unpaused", self, "_on_game_unpaused")

func _exit_tree() -> void:
	Events.main.disconnect("game_paused", self, "_on_game_paused")
	Events.main.disconnect("game_unpaused", self, "_on_game_unpaused")


func _on_game_paused() -> void:
	hide_menu()

func _on_game_unpaused() -> void:
	show_menu()
