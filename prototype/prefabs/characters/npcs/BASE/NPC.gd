extends Character


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
	var vertical_velocity = 0
	
#	if Input.is_action_pressed("ui_up"):
#		vertical_velocity -= walkspeed * up_down_modifier
#	elif Input.is_action_pressed("ui_down"):
#		vertical_velocity += walkspeed * up_down_modifier
#	else:
#		vertical_velocity = 0
	
	ring_radius += vertical_velocity * delta

func get_position_change(delta:float):
	var velocity = 0
	
#	if Input.is_action_pressed("ui_left"):
#		velocity -= walkspeed
#	elif Input.is_action_pressed("ui_right"):
#		velocity += walkspeed
#	else:
#		velocity = 0
	
	ring_position += (velocity / (ring_radius * 2 * PI)) * delta
