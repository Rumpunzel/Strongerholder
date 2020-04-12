class_name ObjectArea
extends Area


signal added_object(game_object)


var game_object: GameObject = null setget , get_game_object


var objects_in_area: Array = [ ]
var inactive_objects_in_area: Array = [ ]




# Called when the node enters the scene tree for the first time.
func _ready():
	get_game_object()
	
	connect("area_entered", self, "entered")
	connect("area_exited", self, "exited")




func has_object(object: GameObject) -> bool:
	return objects_in_area.has(object)


func entered(new_area: Area):
	var area := new_area as ObjectArea
	
	if area:
		if parse_entering_object(area.game_object):
			emit_signal("added_object", area.game_object)


func exited(new_area: Area):
	var area := new_area as ObjectArea
	
	if area:
		parse_exiting_object(area.game_object)



func parse_entering_object(new_object: GameObject) -> bool:
	if new_object.active and not objects_in_area.has(new_object):
		objects_in_area.append(new_object)
		new_object.connect("died", self, "parse_exiting_object", [new_object])
		
		return true
	elif not inactive_objects_in_area.has(new_object):
		inactive_objects_in_area.append(new_object)
		new_object.connect("activated", self, "parse_acitvating_object", [new_object])
	
	return false


func parse_exiting_object(new_object: GameObject) -> bool:
	if objects_in_area.has(new_object):
		objects_in_area.erase(new_object)
		new_object.disconnect("died", self, "parse_exiting_object")
		
		return true
	elif inactive_objects_in_area.has(new_object):
		inactive_objects_in_area.erase(new_object)
		new_object.disconnect("activated", self, "parse_acitvating_object")
	
	return false


func parse_acitvating_object(new_object: GameObject):
	if inactive_objects_in_area.has(new_object):
		inactive_objects_in_area.erase(new_object)
		new_object.disconnect("activated", self, "parse_acitvating_object")
		parse_entering_object(new_object)




func get_game_object() -> GameObject:
	var node = self
	
	while not game_object:
		node = node.get_parent()
		
		if node is GameObject:
			game_object = node
	
	return game_object
