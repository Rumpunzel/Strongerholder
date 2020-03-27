tool
extends Resource
class_name CityLayout


const BASE_RADIUS:float = 12.0
const RING_GAP:float = 4.0
const ROAD_WIDTH:float = 8.0
const RING_WIDTH:float = 32.0
const SEGMENT_WIDTH:float = 12.0
const SLOPE_RADIUS:float = 420.0

const NUMBER_OF_RINGS:int = 10


const EMPTY = "empty"
const BASE = "base"
const BRIDGE = "bridge"
const FOUNDATION = "foundation"
const STOCKPILE = "stockpile"
const EVERYTHING = "everything"



# Recalculation of the current ring the gameactor is on
static func get_current_ring(ring_radius:float) -> int:
	var ring:int = 0
	
	while ring_radius >= get_radius_minimum(ring + 1):
		ring += 1
	
	return ring


static func get_current_segment(ring:int, rotation:float) -> int:
	var total_segments = get_number_of_segments(ring)
	
	var segment = ((rotation + PI / total_segments) / TAU) * total_segments
	
	return int(segment + total_segments) % total_segments


static func get_slope_sinus(radius:float) -> float:
	return sin(radius / SLOPE_RADIUS)


# The minimum radius in world distance something can travel towards the centre Vector3(0, 0, 0)
static func get_radius_minimum(ring:int) -> float:
	return SLOPE_RADIUS * get_slope_sinus(BASE_RADIUS + (ring * RING_WIDTH))


# The maximum radius in world distance something can travel towards the centre Vector3(0, 0, 0)
static func get_radius_maximum(ring:int) -> float:
	return SLOPE_RADIUS * get_slope_sinus((BASE_RADIUS + (ring * RING_WIDTH) + ROAD_WIDTH))


static func get_height_minimum(ring:int) -> float:
	return SLOPE_RADIUS - sqrt(pow(SLOPE_RADIUS, 2.0) - pow(get_radius_minimum(ring), 2.0))


static func get_height_maximum(ring:int) -> float:
	return SLOPE_RADIUS - sqrt(pow(SLOPE_RADIUS, 2.0) - pow(get_radius_maximum(ring), 2.0))


static func get_number_of_segments(ring:int) -> int:
	return int(max(1, (get_radius_minimum(ring) * 4) / SEGMENT_WIDTH))