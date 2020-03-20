tool
extends Spatial
class_name Rings


const BUILDING_OFFSET:float = 2.0
const BUILDING_SLOP:float = 2.0


export(PackedScene) var building_fundament
export(PackedScene) var bridge

var number_of_rings:int = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	construct_rings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func construct_rings():
	for i in range(number_of_rings):
		build_ring(i)
	
	GameConstants.done_building()


func build_ring(ring_number):
	var number_of_buildings:int = GameConstants.get_number_of_segments(ring_number)
	print("total buildings for ring %d: %d" % [ring_number, number_of_buildings])
	
	for i in range(number_of_buildings):
		var new_building
		var type
		
		if ring_number > 0 and i % int(number_of_buildings / 4.0) == 0:
			new_building = bridge.instance()
			new_building.get_node("block").rotation.x = deg2rad(5) * ring_number
			
			type = GameConstants.BRIDGES
		else:
			new_building = building_fundament.instance()
			
			type = GameConstants.BUILDINGS
		
		add_child(new_building)
		#-sqrt(ring_number * 40)
		new_building.set_world_position(Vector3(0, -pow(ring_number, 2), GameConstants.get_radius_minimum(ring_number) - BUILDING_OFFSET))
		new_building.rotation.y = i * (TAU * (1.0 / number_of_buildings))
		
		new_building.ring_radius = ring_number
		new_building.ring_position = i
		
		GameConstants.register_segment(type, ring_number, i, new_building)
