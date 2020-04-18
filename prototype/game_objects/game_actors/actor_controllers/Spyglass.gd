class_name Spyglass, "res://assets/icons/game_actors/icon_spyglass.svg"
extends Node


export(Constants.Resources) var inventory_trigger: int
export(Array, Constants.Resources) var search_for_resources: Array
export(Array, Constants.Structures) var search_for_structures: Array



func check_for_interaction(_other_hit_box: ObjectHitBox):
	return null



func get_searching_for() -> Array:
	if search_for_resources.empty():
		return search_for_structures
	else:
		return search_for_resources
