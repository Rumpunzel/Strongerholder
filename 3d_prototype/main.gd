class_name Main
extends Node


func _enter_tree() -> void:
	randomize()
	
	# warning-ignore:return_value_discarded
	Events.main.connect("game_pause_requested", self, "_on_game_pause_requested")
	# warning-ignore:return_value_discarded
	Events.main.connect("game_continue_requested", self, "_on_game_continue_requested")
	# warning-ignore:return_value_discarded
	Events.main.connect("game_quit", self, "_on_game_quit")
	
	# warning-ignore:return_value_discarded
	Events.main.connect("game_load_finished", self, "_on_game_load_finished")


func _exit_tree() -> void:
	Events.main.disconnect("game_pause_requested", self, "_on_game_pause_requested")
	Events.main.disconnect("game_continue_requested", self, "_on_game_continue_requested")
	Events.main.disconnect("game_quit", self, "_on_game_quit")
	Events.main.disconnect("game_load_finished", self, "_on_game_load_finished")


func _ready() -> void:
	Events.main.emit_signal("game_load_started")
	_on_game_pause_requested()



func _on_game_pause_requested() -> void:
	get_tree().paused = true
	Events.main.emit_signal("game_paused")

func _on_game_continue_requested() -> void:
	get_tree().paused = false
	Events.main.emit_signal("game_continued")

func _on_game_quit() -> void:
	get_tree().quit()


func _on_game_load_finished() -> void:
	Events.main.emit_signal("game_started")
