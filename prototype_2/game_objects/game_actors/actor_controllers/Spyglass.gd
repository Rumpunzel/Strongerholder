class_name Spyglass, "res://assets/icons/game_actors/icon_spyglass.svg"
extends Area2D


const EMPTY = "Empty"


export(String) var inventory_trigger = EMPTY
export(Array, String) var search_for_resources: Array = [ ]
export(Array, Constants.Structures) var search_for_structures: Array = [ ]




func search_for_target(inventory: Inventory) -> GameObject:
	if not (inventory_trigger == EMPTY or inventory.has(inventory_trigger)):
		return null
	
	var observable_bodies: Array = get_overlapping_bodies()
	var shortest_distance: float = INF
	var closest_target: GameObject = null
	
	for overlapping_body in observable_bodies:
		var distance_to_body: float = global_position.distance_to(overlapping_body.global_position)
		
		if distance_to_body < shortest_distance:
			shortest_distance = distance_to_body
			closest_target = overlapping_body
	print(closest_target)
	return closest_target



func get_searching_for() -> Array:
	return search_for_structures + search_for_resources
