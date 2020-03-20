tool
extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(Hill.NUMBER_OF_RINGS):
		build_plateau(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func build_plateau(ring_number):
	var new_plateau = MeshInstance.new()
	var new_cylinder = CylinderMesh.new()
	var bottom_radius = GameConstants.get_radius_minimum(ring_number)
	var height = Hill.get_ring_height(ring_number + 1) - Hill.get_ring_height(ring_number)
	
	add_child(new_plateau)
	
	new_plateau.name = "plateau_%2d" % [ring_number]
	new_plateau.global_transform.origin.y = Hill.get_ring_height(ring_number + 1) - height * 0.5
	
	new_cylinder.top_radius = bottom_radius + (GameConstants.get_radius_minimum(ring_number) - GameConstants.get_radius_minimum(ring_number - 1)) - GameConstants.RING_GAP
	new_cylinder.bottom_radius = bottom_radius + GameConstants.ROAD_WIDTH
	new_cylinder.height = height
	new_cylinder.flip_faces = true
	
	new_plateau.mesh = new_cylinder
	new_plateau.create_trimesh_collision()
