tool
extends Node


const BASE_RADIUS:float = 12.0
const RING_GAP:float = 4.0
const ROAD_WIDTH:float = 8.0
const RING_WIDTH:float = 32.0
const SEGMENT_WIDTH:float = 12.0
const SLOPE_RADIUS:float = 420.0


const EMPTY = "empty"
const BASE = "base"
const BRIDGES = "bridges"
const FOUNDATIONS = "foundations"
const STOCKPILES = "stockpiles"
const EVERYTHING = "everything"


var radius_minimums:Dictionary = { }
var radius_maximums:Dictionary = { }

var height_minimums:Dictionary = { }
var height_maximums:Dictionary = { }

var slope_sinuses:Dictionary = { }

var segments_dictionary:Dictionary = { }
var search_dictionary:Dictionary = { }



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func done_building():
	construct_search_dictionary()
	CityNavigator.done_building()



func construct_search_dictionary():
	for type in segments_dictionary.values():
		for ring in type.keys():
			for block in type[ring].keys():
				search_dictionary[ring] = search_dictionary.get(ring, { })
				search_dictionary[ring][block] = type[ring][block]



func register_segment(type:String, ring_vector:RingVector, object):
	segments_dictionary[type] = segments_dictionary.get(type, { })
	segments_dictionary[type][ring_vector.ring] = segments_dictionary[type].get(ring_vector.ring, { })
	segments_dictionary[type][ring_vector.ring][ring_vector.segment] = object


func update_segment(old_type:String, new_type:String, ring_vector:RingVector, object):
	segments_dictionary[old_type] = segments_dictionary.get(old_type, { })
	segments_dictionary[old_type][ring_vector.ring] = segments_dictionary[old_type].get(ring_vector.ring, { })
	segments_dictionary[old_type][ring_vector.ring].erase(ring_vector.segment)
	
	register_segment(new_type, ring_vector, object)
	done_building()


func get_object_at_position(ring: int, segment:int, from:String = EVERYTHING):
	var search_through:Dictionary = { }
	
	if not from == EVERYTHING:
		search_through = segments_dictionary[from]
	else:
		search_through = search_dictionary
	
	return search_through.get(int(ring), { }).get(int(segment), null)


# Recalculation of the current ring the gameactor is on
func get_current_ring(ring_radius:float) -> int:
	var ring:int = 0
	
	while ring_radius >= get_radius_minimum(ring + 1):
		ring += 1
	
	return ring


func get_current_segment(ring:int, rotation:float) -> int:
	var total_segments = get_number_of_segments(ring)
	
	var segment = ((rotation + PI / total_segments) / TAU) * total_segments
	
	return int(segment + total_segments) % total_segments


func get_slope_sinus(radius:float) -> float:
	var sinus = slope_sinuses.get(radius)
	
	if sinus == null:
		sinus = sin(radius / SLOPE_RADIUS)
		slope_sinuses[radius] = sinus
	
	return sinus


# The minimum radius in world distance something can travel towards the centre Vector3(0, 0, 0)
func get_radius_minimum(ring:int) -> float:
	var radius = radius_minimums.get(ring)
	
	if radius == null:
		radius = SLOPE_RADIUS * get_slope_sinus(BASE_RADIUS + (ring * RING_WIDTH))
		radius_minimums[ring] = radius
		print("new min radius for %d: %d" % [ring, radius])
	
	return radius


# The maximum radius in world distance something can travel towards the centre Vector3(0, 0, 0)
func get_radius_maximum(ring:int) -> float:
	var radius = radius_maximums.get(ring)
	
	if radius == null:
		radius = SLOPE_RADIUS * get_slope_sinus((BASE_RADIUS + (ring * RING_WIDTH) + ROAD_WIDTH))
		radius_maximums[ring] = radius
		print("new max radius for %d: %d" % [ring, radius])
	
	return radius


func get_height_minimum(ring:int) -> float:
	var height = height_minimums.get(ring)
	
	if height == null:
		height = SLOPE_RADIUS - sqrt(pow(SLOPE_RADIUS, 2.0) - pow(get_radius_minimum(ring), 2.0))
		height_minimums[ring] = height
		#print("new min height for %d: %d" % [ring, height])
	
	return height


func get_height_maximum(ring:int) -> float:
	var height = height_maximums.get(ring)
	
	if height == null:
		height = SLOPE_RADIUS - sqrt(pow(SLOPE_RADIUS, 2.0) - pow(get_radius_maximum(ring), 2.0))
		height_maximums[ring] = height
		#print("new max height for %d: %d" % [ring, height])
	
	return height


func get_number_of_segments(ring:int) -> int:
	return int(max(1, (get_radius_minimum(ring) * 4) / SEGMENT_WIDTH))
