class_name Spyglass, "res://assets/icons/game_actors/icon_spyglass.svg"
extends RayCast2D


export(String) var inventory_trigger = "Empty"
export(Array, String) var search_for_resources: Array = [ ]
export(Array, Constants.Structures) var search_for_structures: Array = [ ]
export(float, 0, 1024) var max_scan_range = 256.0



func get_searching_for() -> Array:
	return search_for_structures + search_for_resources
