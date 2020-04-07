class_name ActorBehavior
extends Node


export(CityLayout.Objects) var inventory_empty
export(CityLayout.Objects) var raw_material
export(CityLayout.Objects) var processed_material



func next_priority(inventory: Array):
	if inventory.empty():
		return inventory_empty
	else:
		return raw_material
