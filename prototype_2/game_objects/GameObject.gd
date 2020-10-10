class_name GameObject, "res://assets/icons/icon_game_object.svg"
extends StaticBody2D


signal activate
signal deactivate
signal died


var active: bool setget set_active, is_active
var type setget set_type, get_type




func _ready():
	pass

func _setup():
	activate_object()




func activate_object():
	emit_signal("activate")

func deactivate_object():
	emit_signal("deactivate")

func object_died():
	emit_signal("died")




func set_active(new_status: bool):
	$hit_box.active = new_status
	active = new_status

func set_type(new_type):
	$hit_box.type = new_type
	type = new_type



func is_active() -> bool:
	active = $hit_box.active
	return active

func get_type():
	return $hit_box.type
