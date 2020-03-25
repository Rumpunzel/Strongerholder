extends BuildingFundament
class_name Bridge



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func handle_highlighted():
	pass


func set_ring_vector(new_vector:Vector2):
	.set_ring_vector(new_vector)
	if not fundament == null:
		fundament.rotation.x = -RingMap.get_slope_sinus(new_vector.x + RingMap.ROAD_WIDTH * 2)
