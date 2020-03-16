extends Node


onready var character = get_node("..")
onready var body = get_node("../body")


# Called when the node enters the scene tree for the first time.
func _ready():
	character.connect("moved", self, "has_moved")
	character.connect("jumped", body, "jump")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func has_moved(new_position:Vector2):
	body.ring_radius = new_position.y
