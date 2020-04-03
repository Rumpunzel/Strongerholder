extends Node
class_name CityNavigator


var ring_map

var pathfinder:AStar2D = null
var astar_nodes:Array = [ ]

var adjacency_matrix:Dictionary = { }

var first_time:bool = true



func _init(new_ring_map):
	ring_map = new_ring_map


func start_building():
	construct_pathfinder()
	#construct_adjanceny_matrix()



func construct_pathfinder():
	if not pathfinder:
		construct_graph()
	
	connect_nodes()


func construct_graph():
	var graph_size:int = 0
	
	pathfinder = AStar2D.new()
	astar_nodes.clear()
	
	for ring in range(CityLayout.NUMBER_OF_RINGS):
		var segments = CityLayout.get_number_of_segments(ring)
		
		for segment in range(segments):
			var radius = CityLayout.get_radius_minimum(ring)
			var point_vector = Vector2(radius + CityLayout.ROAD_WIDTH * 0.5, 0)
			point_vector.rotated((float(segment) / CityLayout.get_number_of_segments(ring)) * TAU)
			
			pathfinder.add_point(graph_size, point_vector)
			astar_nodes.append(Vector2(ring, segment))
			
			graph_size += 1


func connect_nodes():
	var rings = ring_map.search_dictionary
	
	for ring in rings.keys():
		var segments = rings[ring]
		
		if first_time:
			connect_segments(ring)
		
		connect_bridges(ring, segments)


func connect_segments(ring):
	var segments_in_ring = CityLayout.get_number_of_segments(ring)
	
	for segment in range(segments_in_ring):
		var building = (segment + 1) % segments_in_ring
		#print("%s and %s on ring %s" % [segment, building, ring])
		pathfinder.connect_points(astar_nodes.find(Vector2(ring, segment)), astar_nodes.find(Vector2(ring, building)))

func connect_bridges(ring, segments):
	var bridges:Dictionary = ring_map.segments_dictionary[CityLayout.BRIDGE]
	
	for bridge in bridges.get(ring + 1, { }).keys():
		var max_distance = 0.1
		var bridge_connected = false
		
		while not bridge_connected:
			for segment in segments.keys():
				if abs(segment - (bridge / float(CityLayout.get_number_of_segments(ring + 1))) * CityLayout.get_number_of_segments(ring)) <= max_distance:
					pathfinder.connect_points(astar_nodes.find(Vector2(ring, segment)), astar_nodes.find(Vector2(ring + 1, bridge)))
					bridge_connected = true
				
				max_distance += 0.1



func get_shortest_path(start_vector, target_vector) -> Array:
	var start = astar_nodes.find(Vector2(start_vector.ring, start_vector.segment))
	var destination = astar_nodes.find(Vector2(target_vector.ring, target_vector.segment))
	
	var path_ids:Array = [ ]
	var path_vectors:Array = [ ]
	
	if start >= 0 and destination >= 0:
		path_ids = pathfinder.get_id_path(start, destination)
		
		for node in path_ids:
			path_vectors.append(astar_nodes[node])
	
	return path_vectors


func get_nearest(ring_vector:RingVector, type:String):
	var search_through:Dictionary = { }
	
	if not type == CityLayout.EVERYTHING:
		search_through = ring_map.segments_dictionary.get(type, { })
	else:
		search_through = { }
		print("INVALID SEARCH INPUT")
	
	if search_through.empty():
		return null
	else:
		var shortest_path:Array = [ ]
		var target = null
		
		for ring in search_through.keys():
			var segments = search_through[ring]
			
			for segment in segments.keys():
				var path = get_shortest_path(ring_vector, RingVector.new(ring, segment, true))
				
				if (shortest_path.empty() and path.size() > 0) or path.size() < shortest_path.size():
					shortest_path = path
					target = segments[segment]
		
		return target


func get_nearest_thing(ring_vector:RingVector, type:String) -> Array:
	var search_through:Dictionary = ring_map.things_dictionary.get(type, { })
	
	if search_through.empty():
		return [ ]
	else:
		var targets_array = [ ]
		var i = 0
		
		while targets_array.empty() and i < CityLayout.get_number_of_segments(CityLayout.NUMBER_OF_RINGS - 1):
			var ring:int = ring_vector.ring + int(ceil(i / 2.0) * (1 if i % 2 == 0 else -1))
			
			if ring >= 0 and ring < CityLayout.NUMBER_OF_RINGS:
				var search_vector = ring_vector
				
				if not ring == ring_vector.ring:
					var nearest_bridge = get_nearest(ring_vector, CityLayout.BRIDGE)
					
					if nearest_bridge:
						search_vector = nearest_bridge.ring_vector
				
				targets_array = find_thing_on_ring(search_through, ring, search_vector)
			
			i += 1
		
		return targets_array

func find_thing_on_ring(search_through:Dictionary, ring:int, ring_vector:RingVector) -> Array:
	var shortest_path:Array = [ ]
	var targets_array = [ ]
	var j = 0
	var segments = search_through.get(ring, { })
	var segments_in_ring = CityLayout.get_number_of_segments(ring)
	
	while targets_array.empty() and j < segments_in_ring:
		var segment = ring_vector.segment + int(ceil(j / 2.0) * (1 if j % 2 == 0 else -1))
		
		segment = (segment + segments_in_ring) % segments_in_ring
		
		var path = get_shortest_path(ring_vector, RingVector.new(ring, segment, true))
		
		if not segments.get(segment, [ ]).empty() and ((shortest_path.empty() and path.size() > 0) or path.size() < shortest_path.size()):
			shortest_path = path
			targets_array = segments[segment]
		
		j += 1
	
	return targets_array


func construct_adjanceny_matrix():
	var bridges:Dictionary = ring_map.segments_dictionary[ring_map.BRIDGE]
	
	for ring in bridges.keys():
		for segment in bridges[ring].keys():
			var start = Vector2(ring, segment)
			adjacency_matrix[start] = { }
			
			for ring_connection in bridges.keys():
				for segment_connection in bridges[ring_connection].keys():
					var end = Vector2(ring_connection, segment_connection)
					var ring_distance = abs(ring_connection - ring)
					
					var segment_distance = abs(segment_connection - segment)
					segment_distance = (segment_distance % int(ring_map.get_number_of_segments(ring) / 2.0)) if segment_distance > ring_map.get_number_of_segments(ring) / 2.0 else segment_distance
					
					if ring_distance <= 1:
						adjacency_matrix[start][end] = segment_distance + ring_distance * (ring_map.get_ring_width() / ring_map.SEGMENT_WIDTH)
	
	print_adjacency_matrix()

func print_adjacency_matrix():
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
