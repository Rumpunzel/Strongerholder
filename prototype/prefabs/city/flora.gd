tool
extends Spatial


var ring_map
var gui

var max_tree_groups:int = 5



func grow_flora(new_ring_map:RingMap, new_gui:GUI):
	ring_map = new_ring_map
	gui = new_gui
	
	for i in range(1, CityLayout.NUMBER_OF_RINGS):
		construct_ring(i)


func construct_ring(ring_number):
	var number_of_buildings:int = CityLayout.get_number_of_segments(ring_number)
	
	for i in range(number_of_buildings):
		for j in range(max_tree_groups):
			var random_position = (j + 1.0) / float(max_tree_groups + 2)
			
			if randi() % 4 > 0 and (not i == 0 or random_position < 0.4 or random_position > 0.6):
				var ring_vector = RingVector.new(CityLayout.get_radius_minimum(ring_number), (float(i - 0.5 + random_position) / float(number_of_buildings)) * TAU)
				var new_tree = TreePoint.new(ring_vector, ring_map, gui)
				
				add_child(new_tree)
