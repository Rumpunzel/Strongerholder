extends Area
class_name ObjectArea

func is_class(class_type): return class_type == "ObjectArea" or .is_class(class_type)
func get_class(): return "ObjectArea"


var game_object:GameObject = null setget set_game_object, get_game_object

var objects_in_area:Array = [ ]
var inactive_objects_in_area:Array = [ ]


signal added_object




# Called when the node enters the scene tree for the first time.
func _ready():
	game_object = get_game_object()
	
	connect("area_entered", self, "entered")
	connect("area_exited", self, "exited")




func entered(new_area:Area):
	if new_area.is_class("ObjectArea"):
		if parse_entering_object(new_area.game_object):
			emit_signal("added_object", new_area.game_object)


func exited(new_area:Area):
	if new_area.is_class("ObjectArea"):
		parse_exiting_object(new_area.game_object)



func parse_entering_object(new_object:GameObject) -> bool:
	if new_object.alive and new_object.active:
		objects_in_area.append(new_object)
		new_object.connect("died", self, "parse_exiting_object", [new_object])
		
		return true
	else:
		inactive_objects_in_area.append(new_object)
		new_object.connect("activated", self, "parse_acitvating_object", [new_object])
		
		return false


func parse_exiting_object(new_object:GameObject) -> bool:
	if objects_in_area.has(new_object):
		objects_in_area.erase(new_object)
		new_object.disconnect("died", self, "parse_exiting_object")
		
		return true
	elif inactive_objects_in_area.has(new_object):
		inactive_objects_in_area.erase(new_object)
		new_object.disconnect("activated", self, "parse_acitvating_object")
	
	return false


func parse_acitvating_object(new_object:GameObject):
	inactive_objects_in_area.erase(new_object)
	new_object.disconnect("activated", self, "parse_acitvating_object")
	parse_entering_object(new_object)




func set_game_object(new_object:GameObject):
	game_object = new_object



func get_game_object() -> GameObject:
	var node = self
	
	while not game_object:
		node = node.get_parent()
		
		if node is GameObject:
			game_object = node
	
	return game_object
