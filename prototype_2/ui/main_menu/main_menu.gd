class_name MainMenu, "res://class_icons/gui/icon_main_menu.svg"
extends Menu


signal open_class_editor


onready var _title: Label = $SplitContainer/CenterContainer/MenuLayout/Title
onready var _version: Label = $SplitContainer/MarginContainer/Version
onready var _tween: Tween = $Tween

onready var _class_edtior_button : Button = $SplitContainer/CenterContainer/MenuLayout/MenuButtons/ClassEditor




func _ready() -> void:
	_title.text = Main.get_game_title()
	_version.text = Main.get_version()
	
	_class_edtior_button.visible = OS.is_debug_build()




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


func _open_class_editor() -> void:
	if not visible:
		return
	
	emit_signal("open_class_editor")
	hide()


func _quit_game() -> void:
	if not visible:
		return
	
	emit_signal("quit_game")
