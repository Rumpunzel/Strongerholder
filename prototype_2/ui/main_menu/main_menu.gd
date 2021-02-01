class_name MainMenu, "res://class_icons/gui/icon_main_menu.svg"
extends Menu


onready var _title: Label = $SplitContainer/CenterContainer/MenuLayout/Title
onready var _version: Label = $SplitContainer/MarginContainer/Version
onready var _tween: Tween = $Tween




func _ready() -> void:
	_title.text = Main.get_game_title()
	_version.text = Main.get_version()




func _new_game() -> void:
	if not visible:
		return
	
	get_tree().paused = true
	
	emit_signal("new_game")
	hide()


func _load_game() -> void:
	if not visible:
		return
	
	get_tree().paused = true
	
	emit_signal("load_game")
	hide()


func _quit_game() -> void:
	if not visible:
		return
	
	emit_signal("quit_game")
