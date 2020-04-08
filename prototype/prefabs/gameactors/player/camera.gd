extends Camera


export(NodePath) var node_to_follow
export var stick_to_ground: bool = true


onready var ray_cast = RayCast.new()




# Called when the node enters the scene tree for the first time.
func _ready():
	ray_cast.enabled = true
	ray_cast.cast_to.y = -50
	get_node(node_to_follow).call_deferred("add_child", ray_cast)
	ray_cast.transform.origin.y = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stick_to_ground:
		global_transform.origin.y = (ray_cast.get_collision_point().y - global_transform.origin.y) * delta




func add_ui_element(new_element: Control, center_ui: bool = true):
	var new_parent = $ui_layer/control/margin_container if center_ui else $ui_layer/control
	
	new_parent.add_child(new_element)
