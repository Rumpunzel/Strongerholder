extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("..").connect("moved", get_node("../body"), "set_new_coordinates")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
