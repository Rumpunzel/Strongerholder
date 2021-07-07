class_name Main
extends Node

#const SAVE_LOCATION := "user://savegame.save"



func _enter_tree() -> void:
	randomize()
	
	var error := Events.main.connect("game_paused", self, "_on_game_paused")
	assert(error == OK)
	error = Events.main.connect("game_unpaused", self, "_on_game_unpaused")
	assert(error == OK)
	error = Events.main.connect("game_started", self, "_on_game_started")
	assert(error == OK)
	error = Events.main.connect("game_quit", self, "_on_game_quit")
	assert(error == OK)

func _exit_tree() -> void:
	Events.main.disconnect("game_paused", self, "_on_game_paused")
	Events.main.disconnect("game_unpaused", self, "_on_game_unpaused")
	Events.main.disconnect("game_started", self, "_on_game_started")
	Events.main.disconnect("game_quit", self, "_on_game_quit")


func _ready() -> void:
	Events.main.emit_signal("game_started")
#	Events.hud.emit_signal("main_menu_requested")



#func save_game(path: String = SAVE_LOCATION) -> void:
#	var save_file := File.new()
#	var error := save_file.open(path, File.WRITE)
#
#	assert(error == OK)
#	emit_signal("game_save_started")
#
#	#SaverLoader.save_game(save_file, get_tree())
#
#	#yield(SaverLoader, "finished")
#
#	save_file.close()
#
#	emit_signal("game_save_finished")
#
#
#func load_game(path: String = SAVE_LOCATION) -> void:
#	var save_file := File.new()
#	var error := save_file.open(path, File.READ)
#
#	assert(error == OK)
#	emit_signal("game_load_started")
#
#	#SaverLoader.load_game(save_file, get_tree())
#
#	#yield(SaverLoader, "finished")
#
#	save_file.close()
#
#	emit_signal("game_save_finished")
#	print("Game loaded from %s" % SAVE_LOCATION)



func _on_game_paused() -> void:
	get_tree().paused = true

func _on_game_unpaused() -> void:
	get_tree().paused = false


func _on_game_started() -> void:
	pass

func _on_game_quit() -> void:
	get_tree().quit()
