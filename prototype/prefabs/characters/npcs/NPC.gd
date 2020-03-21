tool
extends Character
class_name NPC


var target:Vector2 = Vector2() setget set_target, get_target

var next_path_segment:Vector2 = Vector2()
var walking_direction:Vector2 = Vector2()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Engine.editor_hint and not target == Vector2():
		if current_path.empty():
			update_current_path(Vector2(current_ring, current_segment))
		else:
			if not next_path_segment == Vector2():
				walking_direction = next_path_segment - Vector2(ring_radius, ring_position)
				walking_direction.x /= sqrt(walking_direction.length())
				
				if walking_direction.length() <= 0.1:
					update_current_path(Vector2(current_ring, current_segment))
			else:
				walking_direction = Vector2()
			
			#print("walking_direction: %s" % [walking_direction])



func get_position_change(direction:Vector2) -> Vector2:
	return .get_position_change(walking_direction + direction)

func update_current_path(new_position:Vector2):
	var current_segments:Array = [ ]
	print(new_position)
	current_path = CityNavigator.get_shortest_path(new_position, target)
	
	for segment in range(1, min(3, current_path.size())):
		current_segments.append(RingMap.get_ring_position_of_object(current_path[segment]))
	
	next_path_segment = current_segments[0] if not current_segments.empty() else Vector2()
	print(current_segments)
	if current_segments.size() > 1:
		if not next_path_segment.x == current_segments[1].x:
			next_path_segment.y = current_segments[1].y
		
		next_path_segment.x += RingMap.ROAD_WIDTH / 2.0
	
	next_path_segment = modulo_ring_vector(next_path_segment)
	
	print("current_path: %s\nnext_segment: %s" % [current_path, next_path_segment])



func set_target(new_target:Vector2):
	target = new_target
	update_current_path(Vector2(current_ring, current_segment))


func get_target() -> Vector2:
	return target
