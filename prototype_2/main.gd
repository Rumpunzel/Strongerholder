class_name Main, "res://class_icons/icon_main.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false


signal game_save_started
signal game_save_finished
signal game_load_started
signal game_load_finished


const SAVE_LOCATION := "user://savegame.save"
const VERSION_POSTFIX := "alpha"


export(PackedScene) var default_world_scene := preload("res://game_world/world_scenes/default_scene/default_scene.tscn")


onready var _world = $GameWorld
onready var _gui = $GUILayer/GUI




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	_gui.main_node = self
	
	open_main_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



static func get_game_title() -> String:
	return ProjectSettings.get("application/config/name")

static func get_version() -> String:
	return "version-%s-%s" % [ ProjectSettings.get("application/config/version"), VERSION_POSTFIX ]



func open_main_menu() -> void:
	_world.leave()
	_gui.show_main_menu()


func is_in_game() -> bool:
	return _world.is_in_game()



func save_game(path: String = SAVE_LOCATION) -> void:
	var save_file := File.new()
	
	save_file.open(path, File.WRITE)
	emit_signal("game_save_started")
	
	SaverLoader.save_game(save_file, get_tree())
	
	yield(SaverLoader, "finished")
	
	emit_signal("game_save_finished")


func load_game(path: String = SAVE_LOCATION) -> void:
	_gui.loading_game()
	
	var save_file := File.new()
	
	save_file.open(path, File.READ)
	emit_signal("game_load_started")
	
	SaverLoader.load_game(save_file, get_tree())
	
	yield(SaverLoader, "finished")
	
	emit_signal("game_save_finished")
	print("Game loaded from %s" % SAVE_LOCATION)



func quit_game() -> void:
	get_tree().quit()


func _start_new_game() -> void:
	_enter_world()
	_gui.loading_game(true)

func _input_after_load() -> void:
	emit_signal("game_load_finished")

func _enter_world(scene_to_enter: PackedScene = default_world_scene):
	_world.enter_scene(self, scene_to_enter)
