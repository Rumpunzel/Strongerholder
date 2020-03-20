tool
extends Node


const BASE_RADIUS:float = 12.0
const GROWTH_FACTOR:float = 3.0
const RING_GAP:float = 0.7

const SEGMENT_WIDTH:float = 12.0

const EMPTY = "empty"
const BRIDGES = "bridges"
const BUILDINGS = "buildings"
const EVERYTHING = "everything"


#warning-ignore:unused_class_variable
var radius_minimums:Dictionary = { } setget , get_radius_minimums
#warning-ignore:unused_class_variable
var segments_dictionary:Dictionary = { } setget , get_segments_dictionary
#warning-ignore:unused_class_variable
var search_dictionary:Dictionary = { } setget , get_search_dictionary



# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func done_building():
	$ringmap.done_building()
	$pathfinder.done_building()



func register_segment(type:String, ring:int, segment:int, object):
	$ringmap.register_segment(type, ring, segment, object)


func get_object_at_position(position:Vector2, from:String = GameConstants.EVERYTHING):
	return $ringmap.get_object_at_position(position, from)


func get_ring_position_of_object(segment:Vector2) -> Vector2:
	return $ringmap.get_ring_position_of_object(segment)


# Recalculation of the current ring the character is on
func get_current_ring(ring_radius:float, without_base_radius:bool = true) -> int:
	return $ringmap.get_current_ring(ring_radius, without_base_radius)


func get_current_segment(ring_position:float, ring_radius:float, without_base_radius:bool = true) -> int:
	return $ringmap.get_current_segment(ring_position, ring_radius, without_base_radius)


# The minum radius in world distance something can travel towards the centre Vector3(0, 0, 0)
func get_radius_minimum(ring:int) -> int:
	return $ringmap.get_radius_minimum(ring)


func get_number_of_segments(ring:int) -> int:
	return $ringmap.get_number_of_segments(ring)


func get_radius_minimums() -> Dictionary:
	return $ringmap.radius_minimums


func get_segments_dictionary() -> Dictionary:
	return $ringmap.segments_dictionary


func get_search_dictionary() -> Dictionary:
	return $ringmap.search_dictionary



func get_shortest_path(from:Vector2, to:Vector2) -> Array:
	return $pathfinder.get_shortest_path(from, to)


# The width of a ring in world distance
#	the world is organized in concetric rings around the centre and traveling from ring to ring is only possible in special cases
func get_ring_width() -> float:
	return GameConstants.GROWTH_FACTOR * GameConstants.SEGMENT_WIDTH
