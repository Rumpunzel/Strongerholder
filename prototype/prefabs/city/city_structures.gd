tool
extends Spatial


var ring_map

var gui



func build_everything(new_ring_map:RingMap, new_gui):
	ring_map = new_ring_map
	gui = new_gui

	var new_build_point = BuildPoint.new(CityLayout.BASE, RingVector.new(0, 0), ring_map, gui)
	new_build_point.name = "[base]"
	
	add_child(new_build_point)
	
	for i in range(CityLayout.NUMBER_OF_RINGS):
		construct_ring(i)
	
	ring_map.done_building()


func construct_ring(ring_number):
	var number_of_buildings:int = CityLayout.get_number_of_segments(ring_number)
	var number_of_bridges:int = biggest_factor(number_of_buildings, int((number_of_buildings - 1) / 2.0))
	
	for i in range(number_of_buildings):
		var new_build_point
		var buildying_type
		var ring_vector = RingVector.new(ring_number, i, true)
		
		if ring_number > 0 and i % number_of_bridges == 0:
			buildying_type = CityLayout.BRIDGE
		else:
			buildying_type = CityLayout.FOUNDATION
		
		new_build_point = BuildPoint.new(buildying_type, ring_vector, ring_map, gui)
		
		add_child(new_build_point)
	
	print("total buildings for ring %d: %d" % [ring_number, number_of_buildings])


func biggest_factor(number:int, upper_limit:int = -1, lower_limit:int = 2) -> int:
	var big_fac = number
	
	if upper_limit == -1:
		upper_limit = number
	
	for i in range(lower_limit, upper_limit + 1):
		if number % i == 0:
			big_fac = i
			
	print("the biggest factor for %d is: %d" % [number, big_fac])
	
	return big_fac