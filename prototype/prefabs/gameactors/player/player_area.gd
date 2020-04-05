extends ActorArea



func _process(_delta):
	if not game_object.object_of_interest:
		for object in inactive_objects_in_area:
			object.get_active()
		
		if not objects_in_area.empty():
			highlight_object(objects_in_area.back())



func parse_entering_object(new_object:GameObject) -> bool:
	if .parse_entering_object(new_object):
		if game_object.object_of_interest:
			game_object.object_of_interest.set_highlighted(false)
		
		highlight_object(new_object)
		
		return true
	
	return false


func parse_exiting_object(new_object:GameObject) -> bool:
	if .parse_exiting_object(new_object) and new_object == game_object.object_of_interest:
		new_object.set_highlighted(false)
		
		highlight_object(null)
		
		return true
	
	return false


func highlight_object(new_object):
	game_object.object_of_interest = new_object
	
	if new_object:
		game_object.object_of_interest.set_highlighted(true)
