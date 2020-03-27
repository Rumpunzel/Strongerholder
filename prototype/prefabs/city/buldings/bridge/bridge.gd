extends DoodadBuilding
class_name Bridge



func set_ring_vector(new_vector:RingVector):
	.set_ring_vector(new_vector)
	rotation.x = -CityLayout.get_slope_sinus(new_vector.radius + CityLayout.ROAD_WIDTH * 2)
