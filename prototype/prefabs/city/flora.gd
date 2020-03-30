extends Spatial


export(PackedScene) var tree


var ring_map

var tree_groups:int = 3



func grow_flora(new_ring_map:RingMap):
	ring_map = new_ring_map
	
	for i in range(CityLayout.NUMBER_OF_RINGS):
		construct_ring(i)


func construct_ring(ring_number):
	var number_of_buildings:int = CityLayout.get_number_of_segments(ring_number)
	
	for i in range(number_of_buildings):
		for j in range(tree_groups):
			var new_tree = tree.instance()
			var offset = Vector2(randf() * 2, randf() * 0.2 - 0.1)
			var ring_vector = RingVector.new(CityLayout.get_radius_minimum(ring_number) - offset.x, ((float(i) + 0.5) / float(number_of_buildings)) * TAU + offset.y)
			
			new_tree.setup(ring_map)
			
			add_child(new_tree)
			
			new_tree.ring_vector = ring_vector
