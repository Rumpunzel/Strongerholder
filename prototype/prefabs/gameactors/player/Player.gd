tool
extends GameActor
class_name Player


signal stopped_jumping



# Called when the node enters the scene tree for the first time.
func _ready():
	walkspeed = 0.1
	vertical_walkspeed = 0.05
	
	connect("entered_segment", self, "update_current_path")
	
	InputHandler.current_actor = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func get_input():
#	walking_direction.x = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
#	walking_direction.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
#
#	sprinting = sprint_modifier if Input.is_action_pressed("sprint") else 1.0


func get_world_position():
	return body.global_transform.origin

func update_current_path(new_position:Vector2):
	print("player path: %s" % [CityNavigator.get_shortest_path(new_position, Vector2(2, 11))])
