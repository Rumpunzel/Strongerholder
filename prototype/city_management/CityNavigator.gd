class_name CityNavigator, "res://assets/icons/icon_city_navigator.svg"
extends Resource


var ring_map

var pathfinder: AStar2D = AStar2D.new()
var astar_nodes: Dictionary = { }

var first_time: bool = true
var previous_bridges: int = -1




func _init(new_ring_map):
	ring_map = new_ring_map



func start_building():
	construct_pathfinder()



func construct_pathfinder():
	construct_graph()
	connect_nodes()


func construct_graph():
	var graph_size: int = 0
	
	for ring in range(CityLayout.NUMBER_OF_RINGS):
		var segments = CityLayout.get_number_of_segments(ring)
		
		for segment in range(segments):
			var radius = CityLayout.get_radius_minimum(ring)
			var point_vector = Vector2(radius, 0)
			point_vector.rotated((float(segment) / CityLayout.get_number_of_segments(ring)) * TAU)
			
			pathfinder.add_point(graph_size, point_vector)
			astar_nodes[Vector2(ring, segment)] = graph_size
			
			graph_size += 1


func connect_nodes():
	var bridges: Dictionary = ring_map.structures.dictionary[Constants.Structures.BRIDGE]
	
	for ring in range(CityLayout.NUMBER_OF_RINGS):
		var segments = CityLayout.get_number_of_segments(ring)
		
		if first_time:
			connect_segments(ring)
		
		if not previous_bridges == bridges.size():
			connect_bridges(bridges, ring, segments)
	
	first_time = false
	previous_bridges = bridges.size()


func connect_segments(ring: int):
	var segments_in_ring = CityLayout.get_number_of_segments(ring)
	
	for segment in range(segments_in_ring):
		var building = (segment + 1) % segments_in_ring
		
		pathfinder.connect_points(astar_nodes[Vector2(ring, segment)], astar_nodes[Vector2(ring, building)])


func connect_bridges(bridges: Dictionary, ring: int, segments: int):
	for bridge in bridges.get(ring + 1, { }).keys():
		var max_distance = 0.1
		var bridge_connected = false
		
		while not bridge_connected:
			for segment in range(segments):
				if abs(segment - (bridge / float(CityLayout.get_number_of_segments(ring + 1))) * CityLayout.get_number_of_segments(ring)) <= max_distance:
					pathfinder.connect_points(astar_nodes[Vector2(ring, segment)], astar_nodes[Vector2(ring + 1, bridge)])
					bridge_connected = true
				
				max_distance += 0.1



func get_shortest_path(start_vector: RingVector, target_vector: RingVector) -> Array:
	var start = astar_nodes[Vector2(start_vector.ring, start_vector.segment)]
	var destination = astar_nodes[Vector2(target_vector.ring, target_vector.segment)]
	
	var path_ids: Array = [ ]
	var path_vectors: Array = [ ]
	
	if start >= 0 and destination >= 0:
		path_ids = pathfinder.get_id_path(start, destination)
		
		for node in path_ids:
			path_vectors.append(astar_nodes.keys()[astar_nodes.values()[node]])
	
	return path_vectors



func get_nearest(dictionary: Dictionary, type: int, ring_vector: RingVector, priority_list: Array = [ ]):
	var search_through: Dictionary = dictionary.get(type, { })
	
	if search_through.empty():
		return null
	else:
		var target = null
		var i = 0
		
		while not target and i < CityLayout.NUMBER_OF_RINGS + 1:
			var ring: int = ring_vector.ring + int(ceil(i / 2.0) * (1 if i % 2 == 0 else -1))
			
			if ring >= 0 and ring < CityLayout.NUMBER_OF_RINGS:
				var search_vector = ring_vector
				
				if not ring == ring_vector.ring:
					var current_vector = RingVector.new(CityLayout.get_radius_minimum(ring), ring_vector.rotation)
					var nearest_bridge = get_nearest(ring_map.structures.dictionary, Constants.Structures.BRIDGE, current_vector)
					
					if nearest_bridge:
						search_vector = nearest_bridge.ring_vector
				
				target = find_things_on_ring(search_through, ring, search_vector, priority_list)
			
			i += 1
		
		return target


func find_things_on_ring(search_through: Dictionary, ring: int, ring_vector: RingVector, priority_list: Array = [ ]):
	var shortest_path: float = -1.0
	var target = null
	var j = 0
	var segments = search_through.get(ring, { })
	var segments_in_ring = CityLayout.get_number_of_segments(ring)
	
	while not target and j < segments_in_ring:
		var segment = ring_vector.segment + int(ceil(j / 2.0) * (1 if j % 2 == 0 else -1))
		segment = (segment + segments_in_ring) % segments_in_ring
		
		if segments.get(segment):
			var path_length: float = abs(ring_vector.rotation - (float(segment) / float(segments_in_ring)) * TAU)
			
			while path_length > PI:
				path_length -= PI
			
			if (shortest_path < 0.0 and path_length >= 0.0) or path_length < shortest_path:
				shortest_path = path_length
				var targets_array: Array = segments[segment]
				
				if priority_list.empty():
					target = targets_array.front()
				else:
					for object in targets_array:
						var priority = priority_list.find(object.type)
						
						if priority < 0:
							for prio in priority_list:
								if not (Constants.is_request(prio) and ring_map.resources.has(object, prio)):
									target = object
						
						if not target:
							for i in range(priority):
								if ring_map.structures.dictionary.has(priority_list[i]):
									target = object
									break
						else:
							break
		
		j += 1
	
	return target
