extends Area
class_name ObjectArea


var game_object:GameObject = null setget set_game_object, get_game_object

var objects_in_area:Array = [ ]




# Called when the node enters the scene tree for the first time.
func _ready():
	game_object = get_game_object()
	
	connect("area_entered", self, "entered")
	connect("area_exited", self, "exited")




func entered(new_area):
	objects_in_area.append(new_area.game_object)
#	if object is Player:
#		object.object_of_interest = self
#		set_highlighted(true)

func exited(new_area):
	objects_in_area.erase(new_area.game_object)
#	if object is Player:
#		if object.object_of_interest == self:
#			object.object_of_interest = null
#
#		set_highlighted(false)




func set_game_object(new_object:GameObject):
	game_object = new_object



func get_game_object() -> GameObject:
	var node = self
	
	while not game_object:
		node = node.get_parent()
		
		if node is GameObject:
			game_object = node
	
	return game_object
