class_name Main
extends Node


func _enter_tree() -> void:
	randomize()
	
	# warning-ignore:return_value_discarded
	Events.main.connect("game_paused", self, "_on_game_paused")
	# warning-ignore:return_value_discarded
	Events.main.connect("game_unpaused", self, "_on_game_unpaused")
	# warning-ignore:return_value_discarded
	Events.main.connect("game_quit", self, "_on_game_quit")
	
	# warning-ignore:return_value_discarded
	Events.main.connect("game_load_finished", self, "_on_game_load_finished")


func _exit_tree() -> void:
	Events.main.disconnect("game_paused", self, "_on_game_paused")
	Events.main.disconnect("game_unpaused", self, "_on_game_unpaused")
	Events.main.disconnect("game_quit", self, "_on_game_quit")
	Events.main.disconnect("game_load_finished", self, "_on_game_load_finished")


func _ready() -> void:
	Events.main.emit_signal("game_load_started")
	Events.menu.emit_signal("main_menu_requested")
#	Events.main.emit_signal("game_started")



func _on_game_paused() -> void:
	get_tree().paused = true

func _on_game_unpaused() -> void:
	get_tree().paused = false

func _on_game_quit() -> void:
	get_tree().quit()


func _on_game_load_finished() -> void:
	Events.main.emit_signal("game_started")
