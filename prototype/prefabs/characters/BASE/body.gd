extends KinematicBody


export var gravityscale:float = 200.0

var ring_radius:float = 0
var ring_position:float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collisions = move_and_slide(Vector3(0, -gravityscale, 0) * delta)


func set_new_coordinates(new_coordinates:Dictionary):
	for key in new_coordinates.keys():
		set(key, new_coordinates[key])
	
	translation.z = ring_radius
