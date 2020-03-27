tool
extends PathFinder


var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest



func update_current_path(new_vector:RingVector):
	.update_current_path(new_vector)
	
	if object_of_interest:
		current_segments.append(object_of_interest.ring_vector)




func set_object_of_interest(new_object:GameObject):
	object_of_interest = new_object



func get_object_of_interest() -> GameObject:
	return object_of_interest
