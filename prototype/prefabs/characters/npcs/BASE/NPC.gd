tool
extends Character
class_name NPC


var target:Vector2 = Vector2() setget set_target, get_target



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Engine.editor_hint and not target == Vector2() and current_path.empty():
		update_current_path()



func get_position_change(direction:Vector2) -> Vector2:
	if len(current_path) > 1:
		if abs(current_path[1].x - current_path[0].x) > 0:
			direction.x = 1
		else:
			direction.y = 1
	else:
		direction = Vector2()
	
	return .get_position_change(direction)

func update_current_path():
	current_path = GameConstants.get_shortest_path(Vector2(current_ring, current_segment), target)
	print("current_path: %s" % [current_path])



func set_target(new_target:Vector2):
	target = new_target


func get_target() -> Vector2:
	return target
