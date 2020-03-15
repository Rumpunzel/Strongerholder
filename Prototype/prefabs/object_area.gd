extends Node2D
class_name ObjectArea


export var hit_points = 1

export(NodePath) var collision_to_copy = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if not collision_to_copy == null:
		$collision.shape = get_node(collision_to_copy).shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
