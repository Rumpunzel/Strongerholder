tool
extends BuildingFundament
class_name Bridge


var characters_on_bridge:Array = [ ]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for character in characters_on_bridge:
		character.can_move_rings = true



func entered(body):
	var object = body.get_parent()
	
	if object is Character and not object in characters_on_bridge:
		characters_on_bridge.append(object)
	
	.entered(body)

func exited(body):
	var object = body.get_parent()
	
	if object in characters_on_bridge:
		characters_on_bridge.erase(object)
	
	.exited(body)


func handle_highlighted():
	pass
