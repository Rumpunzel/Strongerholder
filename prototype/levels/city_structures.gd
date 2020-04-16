extends Spatial


export(PackedScene) var base
export(PackedScene) var bridge



func build_everything():
	var new_build_point = base.instance()
	add_child(new_build_point)
	new_build_point._setup(RingVector.new(0, 0))
	
	for i in range(CityLayout.NUMBER_OF_RINGS):
		_construct_ring(i)
	
	RingMap.done_building()


func _construct_ring(ring_number: int):
	var number_of_buildings: int = CityLayout.get_number_of_segments(ring_number)
	var number_of_bridges: int = _biggest_factor(number_of_buildings, int(float(number_of_buildings - 1) / CityLayout.SUB_SEGMENTS), CityLayout.SUB_SEGMENTS + 1)
	
	for i in range(number_of_buildings):
		var new_building
		var ring_vector = RingVector.new(ring_number, i, true)
		
		if i % CityLayout.SUB_SEGMENTS == 0:
			if ring_number > 0 and i % number_of_bridges == 0:
				new_building = bridge.instance()
				add_child(new_building, true)
				new_building._setup(ring_vector)
	
	#print("total buildings for ring %d: %d" % [ring_number, float(number_of_buildings) / CityLayout.SUB_SEGMENTS])


func _biggest_factor(number: int, upper_limit: int = -1, lower_limit: int = 2) -> int:
	var big_fac = number
	
	if upper_limit == -1:
		upper_limit = number
	
	for i in range(lower_limit, upper_limit + 1):
		if number % i == 0:
			big_fac = i
	
	#print("the biggest factor for %d is: %d" % [number, big_fac])
	
	return big_fac
