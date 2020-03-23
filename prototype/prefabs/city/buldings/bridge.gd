tool
extends BuildingFundament
class_name Bridge


#var characters_on_bridge:Array = [ ]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	for character in characters_on_bridge:
#		character.can_move_rings = true



func entered(body):
	var object = body.get_parent()
	
	if object is Character:
		object.movement_limit[0] = [ ]
		object.movement_limit[1] = [ring_position - 20, ring_position + 20]
		print(object.movement_limit)
	
	.entered(body)

func exited(body):
	var object = body.get_parent()
	
	if object is Character:
		object.movement_limit[1] = [ ]
		object.update_ring_vector()
	
	.exited(body)


func handle_highlighted():
	pass



func set_ring_radius(new_radius:float):
	.set_ring_radius(new_radius)
	if not fundament == null:
		fundament.rotation.x = -RingMap.get_slope_sinus(new_radius + RingMap.ROAD_WIDTH * 2)
