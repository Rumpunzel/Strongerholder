tool
extends Spatial


export(PackedScene) var tree


var ring_map

var max_tree_groups:int = 5



func grow_flora(new_ring_map:RingMap):
	ring_map = new_ring_map
	
	for i in range(1, CityLayout.NUMBER_OF_RINGS):
		construct_ring(i)


func construct_ring(ring_number):
	var number_of_buildings:int = CityLayout.get_number_of_segments(ring_number)
	
	for i in range(number_of_buildings):
		for _j in range(randi() % max_tree_groups):
			var new_tree = tree.instance()
			var ring_vector = RingVector.new(CityLayout.get_radius_minimum(ring_number), (float(i) / float(number_of_buildings)) * TAU)
			
			new_tree.setup(ring_map)
			
			add_child(new_tree)
			
			new_tree.ring_vector = ring_vector
