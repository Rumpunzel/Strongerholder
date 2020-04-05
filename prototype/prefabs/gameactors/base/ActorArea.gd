extends ObjectArea
class_name ActorArea



func _ready():
	connect("added_object", self, "check_destination")
	game_object.connect("new_interest", self, "check_destination")
	game_object.connect("acquired_target", self, "check_destination")




func check_destination(_whatever):
	if objects_in_area.has(game_object.object_of_interest) and game_object.object_of_interest.type == game_object.currently_searching_for:
		game_object.set_currently_searching_for(null)
