extends DoodadBuilding
class_name Bridge



func set_ring_vector(new_vector:Vector2):
	.set_ring_vector(new_vector)
	rotation.x = -RingMap.get_slope_sinus(new_vector.x + RingMap.ROAD_WIDTH * 2)
