extends GameActor
class_name NPC

func is_class(type): return type == "NPC" or .is_class(type)
func get_class(): return "NPC"


var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest



# Called when the node enters the scene tree for the first time.
func _ready():
	pathfinder.register_actor(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not pathfinding_target:
		var nearest_stockpile = RingMap.city_navigator.get_nearest(ring_vector, RingMap.STOCKPILES)
		
		if nearest_stockpile:
			object_of_interest = RingMap.segments_dictionary[RingMap.STOCKPILES][nearest_stockpile.ring][nearest_stockpile.segment]
			set_pathfinding_target(nearest_stockpile)
			print(object_of_interest)




func set_object_of_interest(new_object:GameObject):
	object_of_interest = new_object



func get_object_of_interest() -> GameObject:
	return object_of_interest

