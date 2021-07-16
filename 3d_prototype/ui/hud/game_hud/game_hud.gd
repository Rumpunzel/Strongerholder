class_name GameHUD
extends GUILayerBase

export(Resource) var _game_paused_channel
export(Resource) var _game_continued_channel


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_game_paused_channel.connect("raised", self, "_on_game_paused")
	# warning-ignore:return_value_discarded
	_game_continued_channel.connect("raised", self, "_on_game_continued")

func _exit_tree() -> void:
	_game_paused_channel.disconnect("raised", self, "_on_game_paused")
	_game_continued_channel.disconnect("raised", self, "_on_game_continued")


func _on_game_paused() -> void:
	hide_menu()

func _on_game_continued() -> void:
	show_menu()
