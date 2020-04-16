extends Spatial


export(PackedScene) var tree


func grow_flora():
	for i in range(1, CityLayout.NUMBER_OF_RINGS):
		construct_ring(i)


func construct_ring(ring_number):
	var number_of_buildings: int = CityLayout.get_number_of_segments(ring_number)
	
	for i in range(number_of_buildings):
		if not i == 0 and i % 3 == 0:
			var ring_vector = RingVector.new(CityLayout.get_radius_minimum(ring_number), (float(i) / float(number_of_buildings)) * TAU)
			var new_tree = tree.instance()
			add_child(new_tree, true)
			new_tree._setup(ring_vector)
