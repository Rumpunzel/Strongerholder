tool
extends Node


const BASE_RADIUS:float = 12.0
const GROWTH_FACTOR:float = 3.0
const RING_GAP:float = 0.4

const SEGMENT_WIDTH:float = 12.0


var radius_minimums:Dictionary = { }
var ring_widths:Dictionary = { }
var side_lengths:Dictionary = { }



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



# Recalculation of the current ring the character is on
func get_current_ring(ring_radius:float, without_base_radius:bool = true) -> int:
	var ring:int = 0
	
	if without_base_radius:
		ring_radius += BASE_RADIUS
	
	while ring_radius >= get_radius_minimum(ring + 1):
		ring += 1
	
	return ring


# The minum radius in world distance something can travel towards the centre Vector3(0, 0, 0)
func get_radius_minimum(ring:int) -> int:
	var radius = radius_minimums.get(ring)
	
	if radius == null:
		radius = int(BASE_RADIUS + (ring * GROWTH_FACTOR * BASE_RADIUS))
		radius_minimums[ring] = radius
		print("new radius for %d: %d" % [ring, radius])
	
	return radius


# The width of a ring in world distance
#	the world is organized in concetric rings around the centre and traveling from ring to ring is only possible in special cases
func get_ring_width(ring:int) -> float:
	var width = ring_widths.get(ring)
	
	if width == null:
		width = get_radius_minimum(ring + 1) - get_radius_minimum(ring)
		ring_widths[ring] = width
	
	return width


func get_number_of_segments(ring:int) -> int:
	return int(get_radius_minimum(ring) * 4 / SEGMENT_WIDTH)


func get_segment(ring_position:float, ring_radius:float, without_base_radius:bool = true) -> int:
	var current_ring = get_current_ring(ring_radius, without_base_radius)
	var total_segments = get_number_of_segments(current_ring)
	
	return int(((ring_position + PI / total_segments) / TAU) * total_segments) % total_segments
