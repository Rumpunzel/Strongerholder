extends Node
class_name CityNavigator


var ring_map

var pathfinder:AStar
var astar_nodes:Array = [ ]

var adjacency_matrix:Dictionary = { }



func _init(new_ring_map):
	ring_map = new_ring_map


func start_building():
	construct_pathfinder()
	#construct_adjanceny_matrix()



func construct_pathfinder():
	construct_graph()
	connect_nodes()


func construct_graph():
	var city = ring_map.segments_dictionary
	var graph_size:int = 0
	
	pathfinder = AStar.new()
	astar_nodes.clear()
	
	for type in city.keys():
		var weight = 1.0 if type == CityLayout.BRIDGE else 1.0
		var rings = city[type]
		
		for ring in rings.keys():
			var segments = rings[ring]
			
			for segment in segments.keys():
				var building = segments[segment]
				
				pathfinder.add_point(graph_size, building.world_position, weight)
				astar_nodes.append(Vector2(ring, segment))
				
				graph_size += 1
	
	
func connect_nodes():
	var rings = ring_map.search_dictionary
	var bridges:Dictionary = ring_map.segments_dictionary[CityLayout.BRIDGE]
	
	for ring in rings.keys():
		var segments = rings[ring]
		
		for segment in segments.keys():
			var seg_size = segments.size()
			
			for building in range(seg_size + 1):
				if abs(segment - building) == 1 and not segment == (building % seg_size):
					building %= seg_size
					
					pathfinder.connect_points(astar_nodes.find(Vector2(ring, segment)), astar_nodes.find(Vector2(ring, building)))
		
		for bridge in bridges.get(ring + 1, { }).keys():
			var max_distance = 0.5
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
		
		for ring in search_through.keys():
			var segments = search_through[ring]
			
			for segment in segments.keys():
				pass
				var path = get_shortest_path(ring_vector, RingVector.new(ring, segment, true))

				if (shortest_path.empty() and path.size() > 0) or path.size() < shortest_path.size():
					shortest_path = path
		
		var target = shortest_path.back() if not shortest_path.empty() else null
		
		return RingVector.new(target.x, target.y, true) if target else null



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