tool
extends Spatial


export(PackedScene) var building_fundament
export(PackedScene) var bridge



# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(Hill.NUMBER_OF_RINGS):
		construct_ring(i)
	
	GameConstants.done_building()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func construct_ring(ring_number):
	var number_of_buildings:int = GameConstants.get_number_of_segments(ring_number)
	
	for i in range(number_of_buildings):
		var new_building
		var type
		
		if ring_number > 0 and i % int(number_of_buildings / 4.0) == 0:
			new_building = bridge.instance()
			
			type = GameConstants.BRIDGES
		else:
			new_building = building_fundament.instance()
			
			type = GameConstants.BUILDINGS
		
		add_child(new_building)
		
		var ring_radius = GameConstants.get_radius_minimum(ring_number)
		var ring_position = i * (TAU * (1.0 / number_of_buildings))
		
		new_building.set_world_position(Vector3(0, Hill.get_ring_height(ring_number), ring_radius - Hill.BUILDING_OFFSET))
		new_building.rotation.y = ring_position
		
		new_building.ring_radius = ring_radius
		new_building.ring_position = ring_position
		
		GameConstants.register_segment(type, ring_number, i, new_building)
	
	print("total buildings for ring %d: %d" % [ring_number, number_of_buildings])
