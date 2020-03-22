tool
extends Spatial


var built:bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.editor_hint:
		build_everything()


func _process(_delta):
	if Engine.editor_hint and not built:
		build_everything()



func build_everything():
	for i in range(Hill.NUMBER_OF_RINGS):
		build_plateau(i)
	
	built = true


func build_plateau(ring_number):
	var new_plateau = MeshInstance.new()
	var new_cylinder = CylinderMesh.new()
	var bottom_radius = RingMap.get_radius_minimum(ring_number)
	var height = Hill.get_ring_height(ring_number + 1) - Hill.get_ring_height(ring_number)
	
	add_child(new_plateau)
	
	new_plateau.name = "plateau_%2d" % [ring_number]
	new_plateau.global_transform.origin.y = Hill.get_ring_height(ring_number + 1) - height * 0.5
	
	new_cylinder.top_radius = bottom_radius + (RingMap.get_radius_minimum(ring_number) - RingMap.get_radius_minimum(ring_number - 1)) - RingMap.RING_GAP
	new_cylinder.bottom_radius = bottom_radius + RingMap.ROAD_WIDTH
	new_cylinder.height = height
	new_cylinder.flip_faces = true
	
	new_plateau.mesh = new_cylinder
	new_plateau.create_trimesh_collision()
