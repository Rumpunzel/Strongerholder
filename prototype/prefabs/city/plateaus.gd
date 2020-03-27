tool
extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready():
	build_everything()



func build_everything():
	for i in range(CityLayout.NUMBER_OF_RINGS):
		build_plateau(i)


func build_plateau(ring_number):
	var new_plateau = CSGPolygon.new()
	var inner_radius = CityLayout.get_radius_minimum(ring_number) - CityLayout.RING_GAP
	var outer_radius = CityLayout.get_radius_maximum(ring_number) + 1
	var inner_height = CityLayout.get_height_minimum(ring_number)
	var outer_height = CityLayout.get_height_maximum(ring_number)
	
	add_child(new_plateau)
	
	new_plateau.name = "plateau_%2d" % [ring_number]
	
	new_plateau.polygon[0] = Vector2(inner_radius, -64)
	new_plateau.polygon[1] = Vector2(inner_radius, inner_height)
	new_plateau.polygon[2] = Vector2(outer_radius, outer_height)
	new_plateau.polygon[3] = Vector2(outer_radius, -64)
	
	new_plateau.mode = CSGPolygon.MODE_SPIN
	new_plateau.spin_sides = 32
	new_plateau.use_collision = true
