class_name ActorArea
extends ObjectArea



func _ready():
	get_game_object()



func parse_entering_object(new_object: GameObject) -> bool:
	if game_object.player_controlled:
		if .parse_entering_object(new_object):
			if game_object.get_object_of_interest():
				game_object.get_object_of_interest().set_highlighted(false)
			
			highlight_object(new_object)
			
			return true
		
		return false
	else:
		return .parse_entering_object(new_object)


func parse_exiting_object(new_object: GameObject) -> bool:
	if game_object.player_controlled:
		if .parse_exiting_object(new_object) and new_object == game_object.get_object_of_interest():
			new_object.set_highlighted(false)
			
			highlight_object(null)
			
			return true
		
		return false
	else:
		return .parse_entering_object(new_object)


func highlight_object(new_object):
	if not game_object.get_object_of_interest() or not new_object:
		game_object.set_object_of_interest(new_object)

	if new_object:
		game_object.get_object_of_interest().set_highlighted(true)
