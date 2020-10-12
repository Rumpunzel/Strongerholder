class_name Spyglass, "res://assets/icons/game_actors/icon_spyglass.svg"
extends Area2D


const EMPTY = "EMPTY"


export(String) var inventory_trigger = EMPTY
export(Array, String) var search_for_resources: Array = [ ]
export(Array, Constants.Structures) var search_for_structures: Array = [ ]




func search_for_target(inventory: Inventory) -> GameObject:
	if not (inventory_trigger == EMPTY or inventory.has(inventory_trigger)):
		return null
	
	var observable_bodies: Array = get_overlapping_bodies()
	var shortest_distance: float = INF
	var closest_target: GameObject = null
	
	# Check all the bodies in the Area2D
	for overlapping_body in observable_bodies:
		var body_type: String = overlapping_body.type
		
		# Check that the body has the proper type
		if search_for_resources.has(body_type) or search_for_structures.has(body_type):
			var requester_group: Array = get_tree().get_nodes_in_group("%s%s" % [GameResource.REQUEST, body_type])
			
			# Check that the potential target's type is actually requested
			if not (requester_group.empty() or requester_group.has(overlapping_body.get_owner())):
				# Check if the potential target is the nearest one
				var simple_path: PoolVector2Array = get_tree().get_root().get_node("test/navigation").get_simple_path(global_position, overlapping_body.global_position)
				var distance_to_body: float = 0.0
				var path_index: int = 0
				
				while path_index < simple_path.size() - 1:
					distance_to_body += simple_path[path_index].distance_to(simple_path[path_index + 1])
					path_index += 1
				
				if distance_to_body < shortest_distance:
					shortest_distance = distance_to_body
					closest_target = overlapping_body
	
	return closest_target



func get_searching_for() -> Array:
	return search_for_structures + search_for_resources
