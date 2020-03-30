extends AnimatedSprite3D


enum { DOWN, RIGHT, TOP, LEFT }

const DIRECTIONS = { DOWN: "_d", TOP: "_t", RIGHT: "_r", LEFT: "_l" }

onready var camera = get_viewport().get_camera()

var previous_direction:Vector2 = Vector2()
var camera_offset:int = 0



func _ready():
	playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not camera == null:
		var angle = int(rad2deg((Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2(camera.global_transform.origin.x, camera.global_transform.origin.z))))) % 360
		camera_offset = int(min(angle / 60.0, 2)) if angle >= 0 else int(max(angle / 60.0, -2)) + DIRECTIONS.size()
		change_animation(previous_direction)
		#flip_h = global_transform.origin.distance_to(camera.global_transform.origin) > camera.global_transform.origin.distance_to(Vector3())



func change_animation(new_direction:Vector2):
	var animation_name:String
	
	if new_direction.length() == 0:
		animation_name = "idle" + vector_direction(previous_direction)
	else:
		animation_name = "run" + vector_direction(new_direction)
		previous_direction = new_direction
	
	animation = animation_name


func vector_direction(new_direction:Vector2) -> String:
	if abs(new_direction.x) >= abs(new_direction.y):
		if new_direction.x >= 0:
			return DIRECTIONS[(DOWN + camera_offset) % DIRECTIONS.size()]
		else:
			return DIRECTIONS[(TOP + camera_offset) % DIRECTIONS.size()]
	else:
		if new_direction.y >= 0:
			return DIRECTIONS[(RIGHT + camera_offset) % DIRECTIONS.size()]
		else:
			return DIRECTIONS[(LEFT + camera_offset) % DIRECTIONS.size()]
