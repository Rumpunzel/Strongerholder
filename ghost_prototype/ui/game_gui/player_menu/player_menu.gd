class_name PlayerMenu
extends ItemList


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_icon_item(load("res://assets/sprites/tools/axe.png"))
	add_icon_item(load("res://assets/sprites/tools/knife.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
