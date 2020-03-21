tool
extends Character
class_name Player


signal stopped_jumping



# Called when the node enters the scene tree for the first time.
func _ready():
	walkspeed = 5.0
	vertical_walkspeed = 3.0
	
	connect("entered_segment", self, "update_current_path")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()



func get_input():
	sprinting = sprint_modifier if Input.is_action_pressed("sprint") else 1.0
	
	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_released("jump"):
		body.jump()
		
		emit_signal("stopped_jumping")


func get_position_change(direction:Vector2) -> Vector2:
	direction.x = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	return .get_position_change(direction)


func get_world_position():
	return body.global_transform.origin

func update_current_path(new_position:Vector2):
	print("player path: %s" % [CityNavigator.get_shortest_path(new_position, Vector2(2, 11))])
