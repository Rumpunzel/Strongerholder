class_name ObjectStats
extends Resource


export var hit_points_max: float = 10.0 setget invalid, get_hit_points_max
export var indestructible: bool = false setget invalid, get_indestructible

export(Array, Constants.Objects) var starting_inventory: Array setget , get_starting_inventory



func invalid(_input):
	print("THIS IS A READ ONLY VARIABLE")
	assert(false)


func get_hit_points_max() -> float:
	return hit_points_max

func get_indestructible() -> bool:
	return indestructible

func get_starting_inventory() -> Array:
	return starting_inventory
