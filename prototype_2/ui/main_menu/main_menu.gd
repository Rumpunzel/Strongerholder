class_name MainMenu
extends Control


const _VERSION_POSTFIX: String = " alpha"


onready var _title: Label = $split_container/center_container/menu_layout/title
onready var _version: Label = $split_container/margin_container/version




func _ready():
	_title.text = ProjectSettings.get("application/config/name")
	_version.text = "version %s%s" % [ProjectSettings.get("application/config/version"), _VERSION_POSTFIX]




func _new_game():
	get_tree().paused = true
	
	var load_process = get_tree().change_scene_to(load("res://test.tscn"))
	
	if load_process == OK:
		SaveHandler.starting_new_game(true)
	else:
		assert(false)


func _load_game():
	get_tree().paused = true
	
	SaveHandler.load_game("user://savegame.save")
		
	print("Game loaded from %s" % "user://savegame.save")


func _quit_game():
	get_tree().quit()
