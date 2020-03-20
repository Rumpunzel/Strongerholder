tool
extends Character
class_name NPC


var target:Vector2 = Vector2() setget set_target, get_target

var path_segments:Array = [ ]
var walking_direction:Vector2 = Vector2()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Engine.editor_hint and not target == Vector2():
		if current_path.empty():
			update_current_path(Vector2(current_ring, current_segment))
		
		if path_segments.size() > 1:
			walking_direction = path_segments[1] - Vector2(ring_radius, ring_position)
			
			if walking_direction.length() <= 0.1:
				update_current_path(Vector2(current_ring, current_segment))
		else:
			walking_direction = Vector2()
		
		#print("walking_direction: %s" % [walking_direction])



func get_position_change(direction:Vector2) -> Vector2:
	return .get_position_change(walking_direction + direction)

func update_current_path(new_position:Vector2):
	current_path = GameConstants.get_shortest_path(new_position, target)
	
	path_segments = [ ]
	
	for segment in current_path:
		path_segments.append(GameConstants.get_ring_position_of_object(segment))
	
	print("current_path: %s\nnext_segment: %s" % [current_path, path_segments])



func set_target(new_target:Vector2):
	target = new_target
	update_current_path(Vector2(current_ring, current_segment))


func get_target() -> Vector2:
	return target
