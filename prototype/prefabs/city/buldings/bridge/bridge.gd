extends DoodadBuilding
class_name Bridge



func set_ring_vector(new_vector:RingVector):
	.set_ring_vector(new_vector)
	rotation.x = -RingMap.get_slope_sinus(new_vector.radius + RingMap.ROAD_WIDTH * 2)
