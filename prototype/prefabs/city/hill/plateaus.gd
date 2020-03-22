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
	var new_plateau = CSGPolygon.new()
	var inner_radius = RingMap.get_radius_minimum(ring_number) - RingMap.RING_GAP
	var outer_radius = RingMap.get_radius_maximum(ring_number) + 1
	var height = Hill.get_ring_height(ring_number)
	
	add_child(new_plateau)
	
	new_plateau.name = "plateau_%2d" % [ring_number]
	#new_plateau.global_transform.origin.y = Hill.get_ring_height(ring_number + 1) - height * 0.5
	
	new_plateau.polygon[0] = Vector2(inner_radius - RingMap.RING_GAP * 2.0, -32)
	new_plateau.polygon[1] = Vector2(inner_radius, height)
	new_plateau.polygon[2] = Vector2(outer_radius, height)
	new_plateau.polygon[3] = Vector2(RingMap.get_radius_minimum(ring_number + 1) - RingMap.RING_GAP * 2.0, -32)
	
	new_plateau.mode = CSGPolygon.MODE_SPIN
	new_plateau.spin_sides = 32
	new_plateau.use_collision = true
