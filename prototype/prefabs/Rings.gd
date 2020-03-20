tool
extends Spatial
class_name Rings


const BUILDING_OFFSET:float = 2.0
const BUILDING_SLOP:float = 2.0


export(PackedScene) var building_fundament
export(PackedScene) var bridge


onready var rings = Spatial.new()
onready var plateaus = Spatial.new()


var number_of_rings:int = 10



# Called when the node enters the scene tree for the first time.
func _ready():
	rings.name = "rings"
	add_child(rings)
	plateaus.name = "plateaus"
	add_child(plateaus)
	
	construct_rings()
	construct_hill()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func construct_rings():
	for i in range(number_of_rings):
		build_ring(i)
	
	GameConstants.done_building()


func build_ring(ring_number):
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
		
		rings.add_child(new_building)
		
		var ring_radius = GameConstants.get_radius_minimum(ring_number)
		var ring_position = i * (TAU * (1.0 / number_of_buildings))
		
		new_building.set_world_position(Vector3(0, get_ring_height(ring_number), ring_radius - BUILDING_OFFSET))
		new_building.rotation.y = ring_position
		
		new_building.ring_radius = ring_radius
		new_building.ring_position = ring_position
		
		GameConstants.register_segment(type, ring_number, i, new_building)
	
	print("total buildings for ring %d: %d" % [ring_number, number_of_buildings])



func construct_hill():
	for i in range(number_of_rings):
		build_plateau(i)


func build_plateau(ring_number):
	var new_plateau = MeshInstance.new()
	var new_cylinder = CylinderMesh.new()
	var bottom_radius = GameConstants.get_radius_minimum(ring_number)
	var height = get_ring_height(ring_number + 1) - get_ring_height(ring_number)
	
	plateaus.add_child(new_plateau)
	new_plateau.name = "plateau_%2d" % [ring_number]
	new_plateau.global_transform.origin.y = get_ring_height(ring_number + 1) - height * 0.5
	
	new_cylinder.top_radius = bottom_radius + (GameConstants.get_radius_minimum(ring_number) - GameConstants.get_radius_minimum(ring_number - 1)) * GameConstants.RING_GAP
	new_cylinder.bottom_radius = bottom_radius + GameConstants.ROAD_WIDTH
	new_cylinder.height = height
	new_cylinder.flip_faces = true
	
	new_plateau.mesh = new_cylinder
	new_plateau.create_trimesh_collision()


func get_ring_height(ring_number:int) -> float:
	return -sqrt(ring_number * 40.0)
