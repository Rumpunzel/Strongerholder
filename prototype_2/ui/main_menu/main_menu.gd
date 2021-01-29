class_name MainMenu
extends Control


const VERSION_POSTFIX: String = " alpha"


onready var _title: Label = $SplitContainer/CenterContainer/MenuLayout/Title
onready var _version: Label = $SplitContainer/MarginContainer/Version




func _ready() -> void:
	_title.text = get_game_title()
	_version.text = get_version()




static func get_game_title() -> String:
	return ProjectSettings.get("application/config/name")

static func get_version() -> String:
	return "version %s%s" % [ProjectSettings.get("application/config/version"), VERSION_POSTFIX]



func _new_game() -> void:
	get_tree().paused = true
	
	get_tree().change_scene_to(SaveHandler.MAIN_SCENE)
	
	SaveHandler.starting_new_game(true)


func _load_game() -> void:
	get_tree().paused = true
	
	SaveHandler.load_game(SaveHandler.SAVE_LOCATION)
	
	print("Game loaded from %s" % SaveHandler.SAVE_LOCATION)


func _quit_game() -> void:
	get_tree().quit()
