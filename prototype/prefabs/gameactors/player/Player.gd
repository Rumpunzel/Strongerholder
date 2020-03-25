extends GameActor
class_name Player

func is_class(type): return type == "Player" or .is_class(type)
func get_class(): return "Player"



# Called when the node enters the scene tree for the first time.
func _ready():
	InputHandler.register_actor(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func update_current_path(new_position:Vector2):
	print("player path: %s" % [CityNavigator.get_shortest_path(new_position, Vector2(2, 11))])
