tool
extends BuildingFundament
class_name Bridge


var current_bodies:Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var area = $block/area
	area.connect("body_entered", self, "set_status")
	area.connect("body_exited", self, "purge_status")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for body in current_bodies:
		body.can_move_rings = true


func set_status(body):
	if "can_move_rings" in body.get_parent():
		current_bodies.append(body.get_parent())

func purge_status(body):
	if "can_move_rings" in body.get_parent():
		current_bodies.erase(body.get_parent())
