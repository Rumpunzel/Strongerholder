class_name Main
extends Node

export(Resource) var _game_pause_requested_channel
export(Resource) var _game_continue_requested_channel
export(Resource) var _game_quit_channel

export(Resource) var _game_load_started_channel
export(Resource) var _game_load_finished_channel

export(Resource) var _game_paused_channel
export(Resource) var _game_continued_channel
export(Resource) var _game_started_channel



func _enter_tree() -> void:
	randomize()
	
	# warning-ignore:return_value_discarded
	_game_pause_requested_channel.connect("raised", self, "_on_game_pause_requested")
	# warning-ignore:return_value_discarded
	_game_continue_requested_channel.connect("raised", self, "_on_game_continue_requested")
	# warning-ignore:return_value_discarded
	_game_quit_channel.connect("raised", self, "_on_game_quit")
	
	# warning-ignore:return_value_discarded
	_game_load_finished_channel.connect("raised", self, "_on_game_load_finished")


func _exit_tree() -> void:
	_game_pause_requested_channel.disconnect("raised", self, "_on_game_pause_requested")
	_game_continue_requested_channel.disconnect("raised", self, "_on_game_continue_requested")
	_game_quit_channel.disconnect("raised", self, "_on_game_quit")
	_game_load_finished_channel.disconnect("raised", self, "_on_game_load_finished")


func _ready() -> void:
	_game_load_started_channel.raise(false)
	_on_game_pause_requested()



func _on_game_pause_requested() -> void:
	get_tree().paused = true
	_game_paused_channel.raise()

func _on_game_continue_requested() -> void:
	get_tree().paused = false
	_game_continued_channel.raise()

func _on_game_quit() -> void:
	get_tree().quit()


func _on_game_load_finished() -> void:
	_game_started_channel.raise()
