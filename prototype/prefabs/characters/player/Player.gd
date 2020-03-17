tool
extends Character
class_name Player


signal stopped_jumping


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()


func get_input():
	sprinting = sprint_modifier if Input.is_action_pressed("sprint") else 1.0
	
	if Input.is_action_just_pressed("jump"):
		jump()
		can_move_rings = true
	
	if Input.is_action_just_released("jump"):
		emit_signal("stopped_jumping")


func get_position_change(velocity:float) -> float:
	velocity = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * walkspeed
	return .get_position_change(velocity)

func get_radius_change(vertical_velocity:float) -> float:
	vertical_velocity = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * walkspeed
	return .get_radius_change(vertical_velocity)
