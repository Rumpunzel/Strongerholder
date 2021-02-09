class_name GameObjectStats
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := [
	"name",
	"hit_points_max",
	"hit_points",
	"indestructible",
]


var hit_points_max: float setget set_hit_points_max

var hit_points: float
var indestructible: bool


func damage(damage_taken: float) -> float:
	if indestructible:
		return 0.0
	
	hit_points -= damage_taken
	
	return damage_taken


func is_dead() -> bool:
	return hit_points <= 0 and not indestructible



func set_hit_points_max(new_max: float) -> void:
	hit_points_max = new_max
	hit_points = hit_points_max
