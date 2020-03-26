extends KinematicBody



onready var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var ring_vector:RingVector setget set_ring_vector, get_ring_vector

var move_direction:Vector2 = Vector2() setget set_move_direction, get_move_direction

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
		look_at(Vector3(0, transform.origin.y, 0), Vector3.UP)
		
		var dir:Vector3 = transform.basis.x * move_direction.y + transform.basis.z * move_direction.x
		fall_speed += default_gravity * fall_modifer * delta
		
		move_and_slide(dir + Vector3(0, jump_speed - fall_speed, 0), Vector3.UP, true)
		
		grounded = is_on_floor()
		
		if grounded:
			fall_speed = 0.0
			jump_speed = 0.0
		
		move_direction = Vector2()



func jump(speed:float = 0.0):
	if speed <= 0.0:
		fall_modifer = 3.0
	elif grounded:
		jump_speed = speed
		fall_modifer = 1.0



func set_ring_vector(new_vector:RingVector):
	translation.z = ring_vector.radius
	ring_vector = new_vector


func set_move_direction(new_dirction:Vector2):
	move_direction = new_dirction



func get_ring_vector() -> RingVector:
	var rad = global_transform.origin.distance_to(Vector3())
	var rot = Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2.DOWN)
	
	ring_vector = RingVector.new(rad, rot)
	
	return ring_vector


func get_move_direction() -> Vector2:
	return move_direction
