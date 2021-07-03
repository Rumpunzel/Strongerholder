class_name Main
extends Node

signal game_save_started
signal game_save_finished
signal game_load_started
signal game_load_finished

const SAVE_LOCATION := "user://savegame.save"

#export var _time_to_pause: float = 0.2

#onready var _tween: Tween = $Tween



func _enter_tree() -> void:
	randomize()
	ServiceLocator.register_service(self)
	
	var error := Events.connect("game_paused", self, "_on_game_paused")
	assert(error == OK)
	
	error = Events.connect("game_unpaused", self, "_on_game_unpaused")
	assert(error == OK)
	
	error = Events.connect("game_started", self, "_on_game_started")
	assert(error == OK)
	
	error = Events.connect("game_quit", self, "_on_game_quit")
	assert(error == OK)

func _ready() -> void:
	Events.emit_signal("main_menu_requested")



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



func _on_game_paused() -> void:
	# warning-ignore:return_value_discarded
	#_tween.interpolate_property(Engine, "time_scale", 1.0, 0.0, _time_to_pause, Tween.TRANS_QUAD, Tween.EASE_IN)
	# warning-ignore:return_value_discarded
	#_tween.start()
	#yield(_tween, "tween_all_completed")
	get_tree().paused = true
	#Engine.time_scale = 1.0

func _on_game_unpaused() -> void:
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	#_tween.interpolate_property(Engine, "time_scale", 0.0, 1.0, _time_to_pause, Tween.TRANS_QUAD, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	#_tween.start()


func _on_game_started() -> void:
	pass

func _on_game_quit() -> void:
	get_tree().quit()
