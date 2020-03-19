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


onready var pathfinder = AStar.new()


var radius_minimums:Dictionary = { }

var segments_dictionary:Dictionary = { }
var search_dictionary:Dictionary = { }

var adjacency_matrix:Dictionary = { }

var astar_nodes:Array = [ ]



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
func get_ring_width() -> float:
	return GROWTH_FACTOR * SEGMENT_WIDTH


func get_number_of_segments(ring:int) -> int:
	return int((get_radius_minimum(ring) * 4) / SEGMENT_WIDTH)


func get_current_segment(ring_position:float, ring_radius:float, without_base_radius:bool = true) -> int:
	var current_ring = get_current_ring(ring_radius, without_base_radius)
	var total_segments = get_number_of_segments(current_ring)
	
	var segment = ((ring_position + PI / total_segments) / TAU) * total_segments
	
	return int(segment) % total_segments


func register_segment(type:String, ring:int, segment:int, object):
	segments_dictionary[type] = segments_dictionary.get(type, { })
	segments_dictionary[type][ring] = segments_dictionary[type].get(ring, { })
	segments_dictionary[type][ring][segment] = object


func get_shortest_path(from:Vector2, to:Vector2) -> Array:
	var start = astar_nodes.find(from)
	var destination = astar_nodes.find(to)
	var path_ids:Array = [ ]
	var path_vectors:Array = [ ]
	
	if start >= 0 and destination >= 0:
		path_ids = pathfinder.get_id_path(start, destination)
		
		for node in path_ids:
			path_vectors.append(astar_nodes[node])
	
	return path_vectors


func _construct_pathfinder():
	var graph_size:int = 0
	
	for ring in search_dictionary.keys():
		for segment in search_dictionary[ring].keys():
			var building = search_dictionary[ring][segment]
			
			pathfinder.add_point(graph_size, building.world_position())
			astar_nodes.append(Vector2(ring, segment))
			
			graph_size += 1
	
	
	var bridges:Dictionary = segments_dictionary[BRIDGES]
	
	for ring in search_dictionary.keys():
		for segment in search_dictionary[ring].keys():
			for building in search_dictionary[ring].keys():
				if abs(segment - building) == 1:
					pathfinder.connect_points(astar_nodes.find(Vector2(ring, segment)), astar_nodes.find(Vector2(ring, building)))
				
			for bridge in bridges.get(ring + 1, { }).keys():
				if abs(segment - (bridge / float(get_number_of_segments(ring + 1))) * get_number_of_segments(ring)) <= 0.5:
					pathfinder.connect_points(astar_nodes.find(Vector2(ring, segment)), astar_nodes.find(Vector2(ring + 1, bridge)))

func _construct_search_dictionary():
	for type in segments_dictionary.values():
		for ring in type.keys():
			for block in type[ring].keys():
				search_dictionary[ring] = search_dictionary.get(ring, { })
				search_dictionary[ring][block] = type[ring][block]


func _construct_adjanceny_matrix():
	var bridges:Dictionary = segments_dictionary[BRIDGES]
	
	for ring in bridges.keys():
		for segment in bridges[ring].keys():
			var start = Vector2(ring, segment)
			adjacency_matrix[start] = { }
			
			for ring_connection in bridges.keys():
				for segment_connection in bridges[ring_connection].keys():
					var end = Vector2(ring_connection, segment_connection)
					var ring_distance = abs(ring_connection - ring)
					
					var segment_distance = abs(segment_connection - segment)
					segment_distance = (segment_distance % int(get_number_of_segments(ring) / 2.0)) if segment_distance > get_number_of_segments(ring) / 2.0 else segment_distance
					
					if ring_distance <= 1:
						adjacency_matrix[start][end] = segment_distance + ring_distance * (get_ring_width() / SEGMENT_WIDTH)
	
	_print_adjacency_matrix()

func _print_adjacency_matrix():
	var matrix_string:String = ""
	var header_string:String = "\n\t"
	var row_counter = 0
	
	
	for row in adjacency_matrix.keys():
		var column_counter = 0
		
		for column in adjacency_matrix.keys():
			if row_counter == 0:
				header_string += "%s\t" % [column]
			
			if column_counter == 0:
				matrix_string += "%s\t" % [row]
			
			var distance = adjacency_matrix.get(row, { }).get(column)
			matrix_string += ("  %2d,\t" % [distance]) if not distance == null else "  --,\t"
			
			column_counter += 1
		
		row_counter += 1
		matrix_string += "\n"
	
	print("%s\n\n%s" % [header_string, matrix_string])


func done_building():
	_construct_search_dictionary()
	_construct_pathfinder()
	_construct_adjanceny_matrix()


func get_object_at_position(position:Vector2, from:String = EVERYTHING):
	var search_through:Dictionary = { }
	
	if not from == EVERYTHING:
		search_dictionary = segments_dictionary[from]
	else:
		search_through = search_dictionary
	
	return search_through.get(int(position.x), { }).get(int(position.y), null)
