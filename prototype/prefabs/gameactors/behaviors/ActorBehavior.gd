class_name ActorBehavior
extends Node


export(CityLayout.OBJECTS) var inventory_empty
export(CityLayout.OBJECTS) var raw_material
export(CityLayout.OBJECTS) var processed_material



func next_priority(inventory:Array):
	if inventory.empty():
		return inventory_empty
	else:
		return raw_material
