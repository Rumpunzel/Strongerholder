class_name CityNavigator
extends Resource


# Reference to the RingMap Singleton
#	this is a reference as accessing the RingMap Singleton from here would create a cylcic dependancy
var _ring_map

var _pathfinder: AStar2D = AStar2D.new()
# Dictionary pointing from Vector2s representing RingVector ring and segment to indexes in the Astar2D _pathfinder
var _astar_nodes: Dictionary = { }

# Variable to ensure that the segments on each ring are connected only once
#	dynamic connections only occur with brides
var _first_time: bool = true
# Same reason here; we only want to reconnect the graph if the amount of bridges has changed
var _previous_bridges: int = -1




func _init(new_ring_map):
	_ring_map = new_ring_map



func start_building():
	_construct_pathfinder()




# Find the shortest path between to RingVectors with the Astar2D search
func get_shortest_path(start_vector: RingVector, target_vector: RingVector) -> Array:
	var start = _astar_nodes[Vector2(start_vector.ring, start_vector.segment)]
	var destination = _astar_nodes[Vector2(target_vector.ring, target_vector.segment)]
	
	var path_ids: Array = [ ]
	var path_vectors: Array = [ ]
	
	if start >= 0 and destination >= 0:
		path_ids = _pathfinder.get_id_path(start, destination)
		
		for node in path_ids:
			path_vectors.append(_astar_nodes.keys()[_astar_nodes.values()[node]])
	
	return path_vectors



# Searches for the nearest target which has the specified type
#	searches in the provided dictionary (stored in the RingMap Singleton)
#	ring_vector is the start position from where is to be searched
#	in sources_to_exclude, an array of types can be specified where the resources shall be delivered afterwards (in descending order of importance)
#		this is only necessary when searching for resources
#		if this is not done, then a STOCKPILE with wood may be returned as a valid target in a search for wood only for the wood to be immediately redelivered to said STOCKPILE
func get_nearest(dictionary: Dictionary, type, ring_vector: RingVector, sources_to_exclude: Array = [ ], object_searching = null):
	var search_through: Dictionary = dictionary.get(type, { })
	
	if search_through.empty():
		return null
	else:
		var target = null
		var i = 0
		
		# Goes through most of the rings in alternating order [ring_vector.ring + (0, -1, 1, -2, 2, ...)]
		#	starts with the ring the ring_vector is on
		while not target and i < CityLayout.NUMBER_OF_RINGS + 1:
			var ring: int = ring_vector.ring + int(ceil(i / 2.0) * (1 if i % 2 == 0 else -1))
			
			if ring >= 0 and ring < CityLayout.NUMBER_OF_RINGS:
				var search_vector = ring_vector
				
				# If the algorithm is searching a different ring from the one ring_vector is on,
				#	it will find the nearest bridge to ring_vector on the new ring and use its position as the new start position
				if not ring == ring_vector.ring:
					var nearest_bridge = get_nearest_bridge(ring_vector, ring)
					
					if nearest_bridge:
						search_vector = nearest_bridge.ring_vector
				
				# Search the current ring for a target which satisfies the conditions set
				target = find_things_on_ring(search_through, ring, search_vector, sources_to_exclude, object_searching)
			
			i += 1
		
		return target


func get_nearest_bridge(ring_vector: RingVector, ring: int):
	var search_through: Dictionary = _ring_map.structures.dictionary.get(Constants.Structures.BRIDGE, { }).get(ring, { })
	var shortest_path: int = -1
	var nearest_bridge = null
	
	for segment in search_through.values():
		var bridge = segment.front()
		var path: int = get_shortest_path(ring_vector, bridge.ring_vector).size()
		
		if (shortest_path < 0 and path >= 0) or path < shortest_path:
			nearest_bridge = bridge
			shortest_path = path
	
	return nearest_bridge


# For information on the parameters, see 'get_nearest()'
func find_things_on_ring(search_through: Dictionary, ring: int, ring_vector: RingVector, sources_to_exclude: Array = [ ], object_searching = null):
	var segments: Dictionary = search_through.get(ring, { })
	var segments_in_ring: int = CityLayout.get_number_of_segments(ring)
	
	var target = null
	
	
	var j: int = 0
	
	# Searches all the segments in the provided ring in alternating order [ring_vector.segment + (0, -1, 1, -2, 2, ...)]
	while not target and j < segments_in_ring:
		var segment: int = ring_vector.segment + int(ceil(j / 2.0) * (1 if j % 2 == 0 else -1))
		# Ensure segment is positive
		segment = (segment + segments_in_ring) % segments_in_ring
		
		if segments.get(segment):
			# Make a simple path estimation based on the rotation of ring_vector and the potential target segment
			var path_length: float = abs(ring_vector.rotation - (float(segment) / float(segments_in_ring)) * TAU)
			
			while path_length > PI:
				path_length -= PI
			
			# Check if the path is a viable candidate
			if path_length >= 0.0:
				var targets_array: Array = segments[segment]
				
				# Return a target that satisfies the conditions as there are no conditions
				if sources_to_exclude.empty():
					target = targets_array.front()
				else:
					# Check all potential targets in the current segment
					for object in targets_array:
						if weakref(object).get_ref() and not (object is GameResource and not object.active and object.called_dibs_by and not object.called_dibs_by == object_searching):
							var object_owner = object.get_owner()
							#print(object_owner.name)
							#print(object.called_dibs_by)
							if false and object_searching == object_owner:
								target = object
							elif not object_owner is GameActor:
								target = is_viable_source(object, sources_to_exclude, object_owner)
							
							if target:
								break
		
		j += 1
	
	return target


func is_viable_source(object, sources_to_exclude, object_owner):
	# Check if the current object is in the sources_to_exclude list
	var excluded_source_index: int = sources_to_exclude.find(object.type)
	
	if excluded_source_index < 0 and object is GameResource and object_owner is GameObject:
		excluded_source_index = sources_to_exclude.find(object_owner.type)
	
	# If the current object is NOT explicitely in the sources_to_exclude list,
	#	make sure that is not implicitely on there
	#	this can only happend if we are searching for something the requests a resource
	if excluded_source_index < 0:
		for source in sources_to_exclude:
			if source is String and source.begins_with("Request_"):
				var object_to_check = object
				
				if object is GameResource and object_owner is GameObject:
					object_to_check = object_owner
				
				if _ring_map.resources.has(object_to_check, source):
					excluded_source_index = sources_to_exclude.find(source)
					break
	
	
	# If the current object is in the sources_to_exclude list,
	#	check if a concrete object exists which is higher on the priority list provided in sources_to_exclude
	#	if that is the case, then the current object becomes a viable target
	#	e.g. sources_to_exclude list is [WOODCUTTERS_HUT, WOOD_REQUEST] while we are looking for something to which to give WOOD
	#		we have found a STOCKPILE with WOOD
	#		we now check the sources_to_exclude list and as the STOCKPILE requests WOOD, it is on the list
	#		now, we check if there exists a WOODCUTTERS_HUT
	#		if it does, then the STOCKPILE becomes a valid target, as the GameActor would take the WOOD from the STOCKPILE and then deliver it to the WOODCUTTERS_HUT
	#		if there is not such HUT, then the STOCKPILE is not a valid target
	if excluded_source_index >= 0:
		for i in range(excluded_source_index):
			if _ring_map.structures.dictionary.has(sources_to_exclude[i]):
				return object
	else:
		return object



func _construct_pathfinder():
	_construct_graph()
	_connect_nodes()


func _construct_graph():
	var graph_size: int = 0
	
	for ring in range(CityLayout.NUMBER_OF_RINGS):
		var segments = CityLayout.get_number_of_segments(ring)
		
		for segment in range(segments):
			var radius = CityLayout.get_radius_minimum(ring)
			var point_vector = Vector2(radius, 0)
			point_vector.rotated((float(segment) / CityLayout.get_number_of_segments(ring)) * TAU)
			
			_pathfinder.add_point(graph_size, point_vector)
			_astar_nodes[Vector2(ring, segment)] = graph_size
			
			graph_size += 1


func _connect_nodes():
	var bridges: Dictionary = _ring_map.structures.dictionary.get(Constants.Structures.BRIDGE, { })
	
	for ring in range(CityLayout.NUMBER_OF_RINGS):
		var segments = CityLayout.get_number_of_segments(ring)
		
		# Connect the segments only once
		if _first_time:
			_connect_segments(ring)
		
		if not _previous_bridges == bridges.size():
			_connect_bridges(bridges, ring, segments)
	
	_first_time = false
	_previous_bridges = bridges.size()


# Connect all the segments for each ring
func _connect_segments(ring: int):
	var segments_in_ring = CityLayout.get_number_of_segments(ring)
	
	for segment in range(segments_in_ring):
		var building = (segment + 1) % segments_in_ring
		
		_pathfinder.connect_points(_astar_nodes[Vector2(ring, segment)], _astar_nodes[Vector2(ring, building)])


# Find connections between rings where bridges have been built
func _connect_bridges(bridges: Dictionary, ring: int, segments: int):
	for bridge in bridges.get(ring + 1, { }).keys():
		# Maximum offset allowed for a bridge to be connected to a node on another ring
		var max_distance: float = 0.1
		var bridge_connected = false
		
		# Search until the bridge is connected at least once
		while not bridge_connected:
			for segment in range(segments):
				if abs(segment - (bridge / float(CityLayout.get_number_of_segments(ring + 1))) * CityLayout.get_number_of_segments(ring)) <= max_distance:
					_pathfinder.connect_points(_astar_nodes[Vector2(ring, segment)], _astar_nodes[Vector2(ring + 1, bridge)])
					bridge_connected = true
				
				max_distance += 0.1
