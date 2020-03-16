extends Character
class_name Player


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_radius_change(delta:float):
	var vertical_velocity = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * walkspeed * up_down_modifier
	
	ring_radius += vertical_velocity * delta

func get_position_change(delta:float):
	var velocity = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * walkspeed
	
	ring_position += (velocity / (ring_radius * 2 * PI)) * delta
