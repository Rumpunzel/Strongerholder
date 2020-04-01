tool
extends GameActor
class_name NPC

func is_class(type): return type == "NPC" or .is_class(type)
func get_class(): return "NPC"


onready var action_timer:Timer = $action_timer


var can_act:bool = true setget set_can_act, get_can_act



# Called when the node enters the scene tree for the first time.
func _ready():
	action_timer.connect("timeout", self, "set_can_act", [true])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if object_of_interest:
		if focus_targets.has(object_of_interest) and can_act:
			interact_with_object(object_of_interest)
			set_pathfinding_target(null)
			pathfinder.object_of_interest = null
	elif not inventory.empty():
		search_for_target(CityLayout.STOCKPILE, false)
	else:
		search_for_target(CityLayout.TREE, true)



func search_for_target(object_type:String, thing:bool):
	if not pathfinding_target:
		var nearest_target
		
		if thing:
			var nearest_targets = ring_map.city_navigator.get_nearest_thing(ring_vector, object_type)
			var shortest_distance = -1
			
			for target in nearest_targets:
				if shortest_distance < 0 or get_world_position().distance_to(target.world_position) < shortest_distance:
					nearest_target = target
		else:
			nearest_target = ring_map.city_navigator.get_nearest(ring_vector, object_type)
		
		if nearest_target:
			set_object_of_interest(nearest_target)
			set_pathfinding_target(nearest_target.ring_vector)


func interact_with_object(object:GameObject = object_of_interest) -> bool:
	var interacted:bool = false
	
	match object.get_class():
		"TreePoint":
			if not object_of_interest.damage(5, self):
				set_object_of_interest(null)
				interacted = true
		_:
			while not inventory.empty():
				object_of_interest.inventory.append(inventory.pop_front())
			
			interacted = object_of_interest.interact("", self)
			set_object_of_interest(null)
	
	can_act = false
	action_timer.start()
	
	return interacted




func set_can_act(new_status:bool):
	can_act = new_status



func get_can_act() -> bool:
	return can_act
