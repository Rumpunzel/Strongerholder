extends GameActor
tool
class_name NPC

func is_class(type): return type == "NPC" or .is_class(type)
func get_class(): return "NPC"


var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest

var did_it_once = false



# Called when the node enters the scene tree for the first time.
func _ready():
	ring_map.connect("city_changed", self, "search_for_target")
	
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	add_child(t)
	t.start()
	yield(t, "timeout")
	
	search_for_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not did_it_once and object_of_interest and focus_target == object_of_interest:
		object_of_interest.interact(self, "")
		set_object_of_interest(null)
		set_pathfinding_target(null)
		did_it_once = true



func search_for_target():
	if not pathfinding_target:
		var nearest_tree = ring_map.city_navigator.get_nearest_thing(ring_vector, CityLayout.TREE)
		var nearest_stockpile = ring_map.city_navigator.get_nearest(ring_vector, CityLayout.STOCKPILE)
		
#		if nearest_stockpile:
#			set_object_of_interest(ring_map.segments_dictionary[CityLayout.STOCKPILE][nearest_stockpile.ring][nearest_stockpile.segment])
#			set_pathfinding_target(nearest_stockpile)
		
		if nearest_tree:
			set_object_of_interest(ring_map.things_dictionary[CityLayout.TREE][nearest_tree.ring][nearest_tree.segment])
			set_pathfinding_target(nearest_tree)




func set_object_of_interest(new_object:GameObject):
	object_of_interest = new_object
	pathfinder.object_of_interest = object_of_interest



func get_object_of_interest() -> GameObject:
	return object_of_interest
