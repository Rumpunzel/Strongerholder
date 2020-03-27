extends Spatial


export(GDScript) var build_point



# Called when the node enters the scene tree for the first time.
func _ready():
	build_everything()



func build_everything():
	var new_build_point = build_point.new(RingMap.BASE, RingVector.new(0, 0))
	new_build_point.name = "[base]"
	
	add_child(new_build_point)
	
	for i in range(RingMap.NUMBER_OF_RINGS):
		construct_ring(i)
	
	RingMap.done_building()


func construct_ring(ring_number):
	var number_of_buildings:int = RingMap.get_number_of_segments(ring_number)
	var number_of_bridges:int = biggest_factor(number_of_buildings, int((number_of_buildings - 1) / 2.0))
	
	for i in range(number_of_buildings):
		var new_build_point
		var buildying_type
		var ring_vector = RingVector.new(ring_number, i, true)
		
		if ring_number > 0 and i % number_of_bridges == 0:
			buildying_type = RingMap.BRIDGE
		else:
			buildying_type = RingMap.FOUNDATION
		
		new_build_point = build_point.new(buildying_type, ring_vector)
		
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
