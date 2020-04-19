class_name Spyglass, "res://assets/icons/game_actors/icon_spyglass.svg"
extends Node


export(Constants.Resources) var inventory_trigger: int
export(Array, Constants.Resources) var search_for_resources: Array = [ ]
export(Array, Constants.Structures) var search_for_structures: Array = [ ]



func get_searching_for() -> Array:
	return search_for_structures + search_for_resources
