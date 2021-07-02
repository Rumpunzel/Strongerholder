class_name Main
extends Node

signal game_save_started
signal game_save_finished
signal game_load_started
signal game_load_finished

signal new_game_started


const SAVE_LOCATION := "user://savegame.save"
const VERSION_POSTFIX := "alpha"



func _enter_tree() -> void:
	randomize()
	ServiceLocator.register_service(self)
	
	var error := Events.connect("game_quit", self, "_on_game_quit")
	assert(error == OK)



static func get_version() -> String:
	return "version-%s-%s" % [ ProjectSettings.get("application/config/version"), VERSION_POSTFIX ]

static func get_service_class() -> String:
	return "Main"


func get_class() -> String:
	return get_service_class()


func save_game(path: String = SAVE_LOCATION) -> void:
	var save_file := File.new()
	var error := save_file.open(path, File.WRITE)
	
	assert(error == OK)
	emit_signal("game_save_started")
	
	#SaverLoader.save_game(save_file, get_tree())
	
	#yield(SaverLoader, "finished")
	
	save_file.close()
	
	emit_signal("game_save_finished")


func load_game(path: String = SAVE_LOCATION) -> void:
	var save_file := File.new()
	var error := save_file.open(path, File.READ)
	
	assert(error == OK)
	emit_signal("game_load_started")
	
	#SaverLoader.load_game(save_file, get_tree())
	
	#yield(SaverLoader, "finished")
	
	save_file.close()
	
	emit_signal("game_save_finished")
	print("Game loaded from %s" % SAVE_LOCATION)



func _on_game_quit() -> void:
	get_tree().quit()


func _start_new_game() -> void:
	emit_signal("new_game_started")

func _input_after_load() -> void:
	emit_signal("game_load_finished")
