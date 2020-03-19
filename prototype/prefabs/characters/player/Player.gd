tool
extends Character
class_name Player


var highlight_distance:float = 7
var highlighted_objects:Array = [ ]


signal stopped_jumping



# Called when the node enters the scene tree for the first time.
func _ready():
	walkspeed = 5.0
	vertical_walkspeed = 3.0
	
	connect("entered_segment", self, "add_highlighted_object")
	connect("left_segment", self, "remove_highlighted_object")
	
	connect("entered_segment", self, "print_path")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()
	
	handle_highlight()



func get_input():
	sprinting = sprint_modifier if Input.is_action_pressed("sprint") else 1.0
	
	if Input.is_action_just_pressed("jump"):
		jump()
	
	if Input.is_action_just_released("jump"):
		body.jump()
		
		emit_signal("stopped_jumping")

func handle_highlight():
	if not Engine.editor_hint:
		for object in highlighted_objects:
			if world_position().distance_to(object.world_position()) < highlight_distance:
				object.highlight(self)
			else:
				object.unhighlight(self)


func get_position_change(velocity:float) -> float:
	velocity = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	return .get_position_change(velocity)

func get_radius_change(vertical_velocity:float) -> float:
	vertical_velocity = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	return .get_radius_change(vertical_velocity)


func add_highlighted_object(new_segment:Vector2):
	var object = GameConstants.get_object_at_position(new_segment)
	
	if not object == null and not highlighted_objects.has(object):
		highlighted_objects.push_front(object)

func remove_highlighted_object(new_segment:Vector2):
	var object = GameConstants.get_object_at_position(new_segment)
	
	if not highlighted_objects == null and highlighted_objects.has(object):
		highlighted_objects.erase(object)


func world_position():
	return body.global_transform.origin

func print_path(new_pos:Vector2):
	print(GameConstants.get_shortest_path(new_pos, Vector2(2, 17)))
