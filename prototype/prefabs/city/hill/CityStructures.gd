extends Spatial
class_name CityStructures

func is_class(type): return type == "CityStructures" or .is_class(type)
func get_class(): return "CityStructures"


export(PackedScene) var fundament
export(PackedScene) var base
export(PackedScene) var building
export(PackedScene) var bridge



# Called when the node enters the scene tree for the first time.
func _ready():
	build_everything()



func build_everything():
	var new_fundament = fundament.instance()
	var new_base = base.instance()
	
	add_child(new_fundament)
	new_fundament.building = new_base
	
	new_fundament.ring_vector = Vector2()
	
	new_fundament.name = "[base]"
	
	RingMap.register_segment(RingMap.BASE, -1, 0, new_fundament)
	
	for i in range(Hill.NUMBER_OF_RINGS):
		construct_ring(i)
	
	RingMap.done_building()


func construct_ring(ring_number):
	var number_of_buildings:int = RingMap.get_number_of_segments(ring_number)
	var number_of_bridges:int = biggest_factor(number_of_buildings, int((number_of_buildings - 1) / 2.0))
	
	for i in range(number_of_buildings):
		var new_fundament = fundament.instance()
		var new_building
		var type
		
		if ring_number > 0 and i % number_of_bridges == 0:
			new_building = bridge.instance()
			new_fundament.name = "[bridge]"
			
			type = RingMap.BRIDGES
		else:
			new_building = building.instance()
			new_fundament.name = "[building]"
			
			type = RingMap.BUILDINGS
		
		add_child(new_fundament)
		new_fundament.building = new_building
		
		var ring_vector = Vector2(RingMap.get_radius_minimum(ring_number), i * (TAU * (1.0 / number_of_buildings)))
		
		new_fundament.set_world_position(Vector3(0, RingMap.get_height_minimum(ring_number), ring_vector.x))
		new_fundament.rotation.y = ring_vector.y
		
		new_fundament.ring_vector = ring_vector
		
		new_fundament.name += "[%s, %s]" % [ring_number, i]
		
		RingMap.register_segment(type, ring_number, i, new_fundament)
	
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
