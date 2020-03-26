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
const BUILDINGS = "buildings"
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



func register_segment(type:String, ring:int, segment:int, object):
	segments_dictionary[type] = segments_dictionary.get(type, { })
	segments_dictionary[type][ring] = segments_dictionary[type].get(ring, { })
	segments_dictionary[type][ring][segment] = object


func get_object_at_position(position:Vector2, from:String = EVERYTHING):
	var search_through:Dictionary = { }
	
	if not from == EVERYTHING:
		search_dictionary = segments_dictionary[from]
	else:
		search_through = search_dictionary
	
	return search_through.get(int(position.x), { }).get(int(position.y), null)


func get_ring_position_of_object(segment:Vector2) -> Vector2:
	var object = search_dictionary.get(int(segment.x), { }).get(int(segment.y), null)
	
	return object.ring_vector if not object == null and object is GameObject else Vector2()


# Recalculation of the current ring the gameactor is on
func get_current_ring(ring_radius:float) -> int:
	var ring:int = 0
	
	while ring_radius >= get_radius_minimum(ring + 1):
		ring += 1
	
	return ring


func get_current_segment(ring_vector:Vector2) -> int:
	var current_ring = get_current_ring(ring_vector.x)
	var total_segments = get_number_of_segments(current_ring)
	
	var segment = ((ring_vector.y + PI / total_segments) / TAU) * total_segments
	
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
