extends Node


onready var pathfinder = AStar.new()

var astar_nodes:Array = [ ]

var adjacency_matrix:Dictionary = { }



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func done_building():
	construct_pathfinder()
	#construct_adjanceny_matrix()



func construct_pathfinder():
	var rings = RingMap.search_dictionary
	
	construct_graph(rings)
	connect_nodes(rings)


func construct_graph(rings:Dictionary):
	var graph_size:int = 0
	
	for ring in rings.keys():
		var segments = rings[ring]
		
		for segment in segments.keys():
			var building = segments[segment]
			
			pathfinder.add_point(graph_size, building.world_position)
			astar_nodes.append(Vector2(ring, segment))
			
			graph_size += 1
	
	
func connect_nodes(rings:Dictionary):
	var bridges:Dictionary = RingMap.segments_dictionary[RingMap.BRIDGES]
	
	for ring in rings.keys():
		var segments = rings[ring]
		
		for segment in segments.keys():
			var seg_size = segments.size()
			
			for building in range(segment, seg_size + 1):
				if abs(segment - building) == 1 and not segment == (building % seg_size):
					building %= seg_size
					pathfinder.connect_points(astar_nodes.find(Vector2(ring, segment)), astar_nodes.find(Vector2(ring, building)))
		
		for bridge in bridges.get(ring + 1, { }).keys():
			var max_distance = 0.5
			var bridge_connected = false
			
			while not bridge_connected:
				for segment in segments.keys():
					if abs(segment - (bridge / float(RingMap.get_number_of_segments(ring + 1))) * RingMap.get_number_of_segments(ring)) <= max_distance:
						pathfinder.connect_points(astar_nodes.find(Vector2(ring, segment)), astar_nodes.find(Vector2(ring + 1, bridge)))
						bridge_connected = true
					
					max_distance += 0.5



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



func construct_adjanceny_matrix():
	var bridges:Dictionary = RingMap.segments_dictionary[RingMap.BRIDGES]
	
	for ring in bridges.keys():
		for segment in bridges[ring].keys():
			var start = Vector2(ring, segment)
			adjacency_matrix[start] = { }
			
			for ring_connection in bridges.keys():
				for segment_connection in bridges[ring_connection].keys():
					var end = Vector2(ring_connection, segment_connection)
					var ring_distance = abs(ring_connection - ring)
					
					var segment_distance = abs(segment_connection - segment)
					segment_distance = (segment_distance % int(RingMap.get_number_of_segments(ring) / 2.0)) if segment_distance > RingMap.get_number_of_segments(ring) / 2.0 else segment_distance
					
					if ring_distance <= 1:
						adjacency_matrix[start][end] = segment_distance + ring_distance * (RingMap.get_ring_width() / RingMap.SEGMENT_WIDTH)
	
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
