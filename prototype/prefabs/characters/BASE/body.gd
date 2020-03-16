tool
extends KinematicBody

onready var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ring_radius:float = 0.0 setget set_ring_radius, get_ring_radius

var fall_speed:float = 0.0
var jump_speed:float = 0.0

var fall_modifer:float = 1.0

var grounded:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not Engine.editor_hint:
		fall_speed += default_gravity * fall_modifer * delta
		var collisions = move_and_slide(Vector3(0, jump_speed - fall_speed, 0), Vector3.UP)
		grounded = is_on_floor()
		if grounded:
			fall_speed = 0.0
			jump_speed = 0.0


func jump(speed:float = 0.0):
	if speed <= 0.0:
		fall_modifer = 3.0
	elif grounded:
		jump_speed = speed
		fall_modifer = 1.0


func set_ring_radius(new_radius:float):
	ring_radius = new_radius
	translation.z = ring_radius


func get_ring_radius() -> float:
	ring_radius = translation.z
	return ring_radius
