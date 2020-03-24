extends PuppetMaster



var start_ring_vector:Vector2 = Vector2() setget set_start_ring_vector, get_start_ring_vector
var pathfinding_target:Vector2 = Vector2() setget set_pathfinding_target, get_pathfinding_target

var current_path:Array = [ ]
var current_segments:Array = [ ]



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func get_input() -> Array:
	var commands:Array = [ ]
	var movement_vector:Vector2
	var next_path_segment:Vector2 = current_segments[0] if not current_segments.empty() else Vector2()
	
	if not next_path_segment == Vector2():
		if current_segments.size() > 1:
			next_path_segment.x += RingMap.ROAD_WIDTH / 2.0
		
		movement_vector = next_path_segment - get_parent().ring_vector
		movement_vector.x /= 256
		
		#print("movement_vector: %s" % [movement_vector])
		
		if movement_vector.length() > 0:
			movement_vector = movement_vector.normalized()
			
			commands.append(MoveCommand.new(movement_vector, false))
	
	return commands


func register_actor(new_actor:GameActor, exclusive_actor:bool = true):
	.register_actor(new_actor, exclusive_actor)
	
	new_actor.connect("moved", self, "set_start_ring_vector")
	new_actor.connect("entered_segment", self, "update_current_path")


func update_current_path(new_position:Vector2):
	current_path = CityNavigator.get_shortest_path(new_position, pathfinding_target)
	current_segments = [ ]
	
	for segment in range(1, current_path.size()):
		current_segments.append(RingMap.get_ring_position_of_object(current_path[segment]))
	
	print("current_path: %s\ncurrent_segments: %s" % [current_path, current_segments])




func set_pathfinding_target(new_target:Vector2):
	pathfinding_target = new_target
	update_current_path(start_ring_vector)


func set_start_ring_vector(new_vector:Vector2):
	start_ring_vector = new_vector



func get_pathfinding_target() -> Vector2:
	return pathfinding_target


func get_start_ring_vector() -> Vector2:
	return start_ring_vector
