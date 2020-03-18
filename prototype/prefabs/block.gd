tool
extends Spatial
class_name BuildingFundament


onready var camera = get_viewport().get_camera()
onready var distance_to_middle = $block.global_transform.origin.distance_to(Vector3())


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func offset(new_offset:Vector3):
	$block.transform.origin = new_offset
	distance_to_middle = $block.global_transform.origin.distance_to(Vector3())
