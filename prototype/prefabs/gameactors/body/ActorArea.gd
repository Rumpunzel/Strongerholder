class_name ActorArea
extends ObjectArea



func _ready():
	connect("added_object", self, "check_destination")
	get_game_object().connect("new_interest", self, "check_destination")
	get_game_object().connect("acquired_target", self, "check_destination")




func check_destination(_whatever):
	if objects_in_area.has(game_object.object_of_interest) and game_object.object_of_interest.type == game_object.currently_searching_for:
		game_object.set_currently_searching_for(null)


func parse_entering_object(new_object: GameObject) -> bool:
	if game_object.player_controlled:
		if .parse_entering_object(new_object):
			if game_object.object_of_interest:
				game_object.object_of_interest.set_highlighted(false)
			
			highlight_object(new_object)
			
			return true
		
		return false
	else:
		return .parse_entering_object(new_object)


func parse_exiting_object(new_object: GameObject) -> bool:
	if game_object.player_controlled:
		if .parse_exiting_object(new_object) and new_object == game_object.object_of_interest:
			new_object.set_highlighted(false)
			
			highlight_object(null)
			
			return true
		
		return false
	else:
		return .parse_entering_object(new_object)


func highlight_object(new_object):
	if not game_object.object_of_interest or not new_object:
		game_object.object_of_interest = new_object
	
	if new_object:
		game_object.object_of_interest.set_highlighted(true)
