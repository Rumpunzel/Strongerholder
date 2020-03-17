tool
extends Node


const BASE_RADIUS:float = 12.0
const GROWTH_FACTOR:float = 3.0
const RING_GAP:float = 0.4

const SEGMENT_WIDTH:float = 4.0
const SHORT_SEGMENT_WIDTH:float = 4.95
const SEGMENT_SIDE_FACTOR:float = 3.0

const LONG_ANGLE:float = 58.716
const SHORT_ANGLE:float = 31.284


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
func get_radius_minimum(ring:int) -> float:
	var radius = radius_minimums.get(ring)
	
	if radius == null:
		radius = BASE_RADIUS * pow(GROWTH_FACTOR, ring)
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


func get_side_length(ring:int) -> float:
	return get_radius_minimum(ring)


func get_segment(ring_position:float, ring_radius:float, without_base_radius:bool = true) -> int:
	var current_ring = get_current_ring(ring_radius, without_base_radius)
	var side_length = get_side_length(current_ring)
	var segments_per_long = int(side_length / SEGMENT_WIDTH)
	var segments_per_short = int(segments_per_long / SEGMENT_SIDE_FACTOR)
	var total_segments = 4 * (segments_per_long + segments_per_short)
	
	ring_position = int(ring_position + (LONG_ANGLE / 2) + 360) % 360
	
	var angle:float = 0.0
	var longs_left:int = segments_per_long
	var shorts_left:int = segments_per_short
	
	for i in range(total_segments):
		if longs_left > 0:
			angle += LONG_ANGLE / segments_per_long
			longs_left -= 1
		elif shorts_left > 0:
			angle += SHORT_ANGLE / segments_per_short
			shorts_left -= 1
		
		if ring_position < angle:
			return (i - 1 + total_segments) % total_segments
			
		if longs_left == 0 and shorts_left == 0:
			longs_left = segments_per_long
			shorts_left = segments_per_short
	
	return 0
