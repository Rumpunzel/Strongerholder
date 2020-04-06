extends Camera


export(NodePath) var ray_cast_node


onready var ray_cast = get_node(ray_cast_node)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin.y = (ray_cast.get_collision_point().y - global_transform.origin.y) * delta


func add_ui_element(new_element:Control, center_ui:bool = true):
	var new_parent = $ui_layer/control/margin_container if center_ui else $ui_layer/control
	
	new_parent.add_child(new_element)
