class_name GameGUI, "res://class_icons/gui/icon_game_gui.svg"
extends Control


onready var _info_menu: InfoMenu = $VerticalDivider/HorizontalDivider/InfoMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func object_selected(new_object: GameObject) -> void:
	_info_menu.object_selected(new_object)
