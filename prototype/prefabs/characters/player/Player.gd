tool
extends Character
class_name Player


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()


func get_input():
	sprinting = sprint_modifier if Input.is_action_pressed("sprint") else 1.0
	can_move_rings = Input.is_action_pressed("jump")
	
	if Input.is_action_just_pressed("jump"):
		jump()


func get_position_change(velocity:float) -> float:
	velocity = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * walkspeed
	return .get_position_change(velocity)

func get_radius_change(vertical_velocity:float) -> float:
	vertical_velocity = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * walkspeed
	return .get_radius_change(vertical_velocity)
