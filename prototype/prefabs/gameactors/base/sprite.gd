extends AnimatedSprite3D


onready var camera = get_viewport().get_camera()



func _ready():
	playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not camera == null:
		flip_h = global_transform.origin.distance_to(camera.global_transform.origin) > camera.global_transform.origin.distance_to(Vector3())
