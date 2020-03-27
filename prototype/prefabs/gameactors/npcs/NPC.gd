extends GameActor
class_name NPC

func is_class(type): return type == "NPC" or .is_class(type)
func get_class(): return "NPC"


var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest

var did_it_once = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pathfinder.register_actor(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not did_it_once:
		if not pathfinding_target:
			var nearest_stockpile = RingMap.city_navigator.get_nearest(ring_vector, RingMap.STOCKPILE)
			
			if nearest_stockpile:
				set_object_of_interest(RingMap.segments_dictionary[RingMap.STOCKPILE][nearest_stockpile.ring][nearest_stockpile.segment])
				set_pathfinding_target(nearest_stockpile)
				print(object_of_interest)
		
		if focus_target == object_of_interest:
			object_of_interest.interact(self, "")
			set_object_of_interest(null)
			set_pathfinding_target(null)
			did_it_once = true




func set_object_of_interest(new_object:GameObject):
	object_of_interest = new_object
	pathfinder.object_of_interest = object_of_interest



func get_object_of_interest() -> GameObject:
	return object_of_interest

