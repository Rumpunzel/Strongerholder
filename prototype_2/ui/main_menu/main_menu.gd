class_name MainMenu, "res://class_icons/gui/icon_main_menu.svg"
extends Menu


onready var _title: Label = $SplitContainer/CenterContainer/MenuLayout/Title
onready var _version: Label = $SplitContainer/MarginContainer/Version
onready var _tween: Tween = $Tween

onready var _class_edtior_button : Button = $SplitContainer/CenterContainer/MenuLayout/MenuButtons/ClassEditor
onready var _test_button: Button = $SplitContainer/CenterContainer/MenuLayout/MenuButtons/Tests




func _ready() -> void:
	_title.text = Main.get_game_title()
	_version.text = Main.get_version()
	
	_class_edtior_button.visible = OS.is_debug_build()
	_test_button.visible = OS.is_debug_build()




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
	
	get_tree().change_scene("res://tools/class_editor/class_editor.tscn")


func _open_tests() -> void:
	if not visible:
		return
	
	hide()
	
	var new_splitter = Node.new()
	get_parent().add_child(new_splitter)
	new_splitter.add_child(load("res://tools/tests/tests.tscn").instance())


func _quit_game() -> void:
	if not visible:
		return
	
	emit_signal("quit_game")
