class_name Main
extends Node

signal main_menu_showed

signal game_save_started
signal game_save_finished
signal game_load_started
signal game_load_finished

signal new_game_started

signal game_quit


const SAVE_LOCATION := "user://savegame.save"
const VERSION_POSTFIX := "alpha"




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	ServiceLocator.register_service(self)
	
	#open_main_menu()



static func get_game_title() -> String:
	return ProjectSettings.get("application/config/name")

static func get_version() -> String:
	return "version-%s-%s" % [ ProjectSettings.get("application/config/version"), VERSION_POSTFIX ]

static func get_service_class() -> String:
	return "Main"


func get_class() -> String:
	return get_service_class()

func open_main_menu() -> void:
	get_tree().paused = true
	emit_signal("main_menu_showed")



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



func quit_game() -> void:
	emit_signal("game_quit")
	
	get_tree().quit()


func _start_new_game() -> void:
	emit_signal("new_game_started")

func _input_after_load() -> void:
	emit_signal("game_load_finished")
