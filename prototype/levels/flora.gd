extends Spatial


var ring_map: RingMap



func grow_flora(new_ring_map: RingMap):
	ring_map = new_ring_map
	
	for i in range(1, CityLayout.NUMBER_OF_RINGS):
		construct_ring(i)


func construct_ring(ring_number):
	var number_of_buildings: int = CityLayout.get_number_of_segments(ring_number)
	
	for i in range(number_of_buildings):
		if not i == 0 and randi() % 5 > 0:
			var ring_vector = RingVector.new(CityLayout.get_radius_minimum(ring_number), (float(i) / float(number_of_buildings)) * TAU)
			add_child(CityObject.new(CityLayout.Objects.TREE, ring_vector, ring_map, false, 1, "Wood"))
