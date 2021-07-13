class_name GameHUD
extends GUILayerBase


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.main.connect("game_paused", self, "_on_game_paused")
	# warning-ignore:return_value_discarded
	Events.main.connect("game_continued", self, "_on_game_continued")

func _exit_tree() -> void:
	Events.main.disconnect("game_paused", self, "_on_game_paused")
	Events.main.disconnect("game_continued", self, "_on_game_continued")


func _on_game_paused() -> void:
	hide_menu()

func _on_game_continued() -> void:
	show_menu()
