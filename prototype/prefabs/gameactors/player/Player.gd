tool
extends GameActor
class_name Player



# Called when the node enters the scene tree for the first time.
func _ready():
	walkspeed = 5
	
	connect("entered_segment", self, "update_current_path")
	
	InputHandler.current_actor = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func get_world_position():
	return body.global_transform.origin

func update_current_path(new_position:Vector2):
	print("player path: %s" % [CityNavigator.get_shortest_path(new_position, Vector2(2, 11))])
