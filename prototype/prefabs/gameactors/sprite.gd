extends AnimatedSprite3D


enum { DOWN, RIGHT, TOP, LEFT }


const DIRECTIONS = { DOWN: "_d", TOP: "_t", RIGHT: "_r", LEFT: "_l" }


export(NodePath) var game_actor_node
export(NodePath) var body_node


var previous_direction: Vector3 = Vector3(1, 0, 0) setget set_previous_direction, get_previous_direction
var previous_action: String = "" setget set_previous_action, get_previous_action


var camera_offset: int = 0


onready var camera = get_viewport().get_camera()
onready var game_actor = get_node(game_actor_node)
onready var body = get_node(body_node)




func _ready():
	body.connect("moved", self, "set_previous_direction")
	game_actor.connect("acted", self, "set_previous_action")
	
	playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not camera == null:
		var angle = int(rad2deg((Vector2(global_transform.origin.x, global_transform.origin.z).angle_to(Vector2(camera.global_transform.origin.x, camera.global_transform.origin.z))))) % 360
		var new_camera_offset = int(min(angle / 60.0, 2)) if angle >= 0 else int(max(angle / 60.0, -2)) + DIRECTIONS.size()
		
		if not new_camera_offset == camera_offset:
			camera_offset = new_camera_offset
			change_animation(previous_direction, previous_action)




func change_animation(new_direction: Vector3, action: String):
	var animation_name: String
	
	if len(action) > 0:
		animation_name = action + vector_direction(previous_direction)
	elif new_direction.length() == 0:
		animation_name = "idle" + vector_direction(previous_direction)
	else:
		animation_name = "run" + vector_direction(new_direction)
		previous_direction = new_direction
	
	animation = animation_name


func vector_direction(new_direction: Vector3) -> String:
	if abs(new_direction.x) > abs(new_direction.z):
		if new_direction.x >= 0:
			return DIRECTIONS[(DOWN + camera_offset) % DIRECTIONS.size()]
		else:
			return DIRECTIONS[(TOP + camera_offset) % DIRECTIONS.size()]
	else:
		if new_direction.z >= 0:
			return DIRECTIONS[(RIGHT + camera_offset) % DIRECTIONS.size()]
		else:
			return DIRECTIONS[(LEFT + camera_offset) % DIRECTIONS.size()]




func set_previous_direction(new_direction:Vector3):
	change_animation(new_direction, previous_action)

func set_previous_action(new_action:String):
	change_animation(previous_direction, new_action)
	previous_action = new_action


func get_previous_direction() -> Vector3:
	return previous_direction

func get_previous_action() -> String:
	return previous_action
