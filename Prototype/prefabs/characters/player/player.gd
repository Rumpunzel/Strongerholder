extends Character
class_name Player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_input():
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= walkspeed
	elif Input.is_action_pressed("ui_right"):
		velocity.x += walkspeed
	else:
		velocity.x = 0
	
	return velocity

func get_motion():
	return .get_motion() + get_input()
