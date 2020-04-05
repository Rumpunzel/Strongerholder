extends Spatial


var ring_map



func build_everything(new_ring_map:RingMap):
	ring_map = new_ring_map

	var new_build_point = CityObject.new(CityLayout.BASE, RingVector.new(0, 0), ring_map)
	
	add_child(new_build_point)
	
	for i in range(CityLayout.NUMBER_OF_RINGS):
		construct_ring(i)
	
	ring_map.done_building()


func construct_ring(ring_number):
	var number_of_buildings:int = CityLayout.get_number_of_segments(ring_number)
	var number_of_bridges:int = biggest_factor(number_of_buildings, int((number_of_buildings - 1) / 2.0))
	
	for i in range(number_of_buildings):
		var buildying_type
		var ring_vector = RingVector.new(ring_number, i, true)
		
		if i % CityLayout.SUB_SEGMENTS == 0:
			if ring_number > 0 and i % number_of_bridges == 0:
				buildying_type = CityLayout.BRIDGE
			else:
				buildying_type = CityLayout.FOUNDATION
			
			add_child(CityObject.new(buildying_type, ring_vector, ring_map, true, 3))
		else:
			ring_map.register_segment(CityLayout.EMPTY, ring_vector, null)
	
	#print("total buildings for ring %d: %d" % [ring_number, float(number_of_buildings) / CityLayout.SUB_SEGMENTS])


func biggest_factor(number:int, upper_limit:int = -1, lower_limit:int = 2) -> int:
	var big_fac = number
	
	if upper_limit == -1:
		upper_limit = number
	
	for i in range(lower_limit, upper_limit + 1):
		if number % i == 0:
			big_fac = i
			
	#print("the biggest factor for %d is: %d" % [number, big_fac])
	
	return big_fac
