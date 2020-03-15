extends KinematicBody2D
class_name Character


export var walkspeed = 10000.0
export var gravityscale = 200.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var motion = get_motion() * delta
	
	move_and_collide(motion)


func get_motion():
	return Vector2(0, gravityscale)
