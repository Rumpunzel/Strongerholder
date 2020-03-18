extends Spatial
class_name GameObject


onready var hit_points:float = hit_points_max

var hit_points_max:float = 10.0

var highlighted:bool = false setget set_highlighted, get_highlighted



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_highlighted()


func highlight(_sender):
	set_highlighted(true)

func unhighlight(_sender):
	set_highlighted(false)

func handle_highlighted():
	pass


func interact(_sender, _action):
	pass


func world_position() -> Vector3:
	return global_transform.origin


func set_highlighted(is_highlighted:bool):
	highlighted = is_highlighted


func get_highlighted() -> bool:
	return highlighted
