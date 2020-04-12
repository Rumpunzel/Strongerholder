class_name ActorArea
extends ObjectArea



func parse_entering_object(new_object: RingObject) -> bool:
	if game_object.player_controlled:
		if .parse_entering_object(new_object):
			if game_object.get_object_of_interest():
				game_object.get_object_of_interest().set_highlighted(false)
			
			highlight_object(new_object)
			
			return true
		
		return false
	else:
		return .parse_entering_object(new_object)


func parse_exiting_object(new_object: RingObject) -> bool:
	if game_object.player_controlled:
		if .parse_exiting_object(new_object) and new_object == game_object.get_object_of_interest():
			new_object.set_highlighted(false)
			
			highlight_object(null)
			
			return true
		
		return false
	else:
		return .parse_exiting_object(new_object)


func highlight_object(new_object):
	var must_be_highlighted: bool = true
	var object: RingObject = game_object.get_object_of_interest()
	
	if new_object and object:
		match Constants.object_type(new_object.type):
			Constants.BUILDINGS:
				must_be_highlighted = true
			Constants.THINGS:
				must_be_highlighted = not Constants.object_type(object.type) == Constants.BUILDINGS
			_:
				must_be_highlighted = false
	
	if must_be_highlighted:
		game_object.set_object_of_interest(new_object)
	
	if new_object:
		game_object.get_object_of_interest().set_highlighted(true)
