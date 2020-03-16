tool
extends Sprite3D


onready var camera = get_viewport().get_camera()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not camera == null:
		var camera_pos = camera.global_transform.origin
		camera_pos.y = global_transform.origin.y
		look_at(camera_pos, Vector3.UP)
		
		flip_h = global_transform.origin.distance_to(camera.global_transform.origin) < camera.global_transform.origin.distance_to(Vector3())
