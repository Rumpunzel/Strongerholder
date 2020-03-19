tool
extends NPC
class_name Woodsman


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.editor_hint:
		set_target(Vector2(2, 17))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
