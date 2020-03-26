extends PuppetMaster



var start_ring_vector:RingVector setget set_start_ring_vector, get_start_ring_vector
var pathfinding_target:RingVector setget set_pathfinding_target, get_pathfinding_target

var current_path:Array = [ ]
var current_segments:Array = [ ]



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func get_input() -> Array:
	var commands:Array = [ ]
	var movement_vector:Vector2
	var next_path_segment:RingVector = current_segments[0] if not current_segments.empty() else null
	
	if next_path_segment:
		next_path_segment.radius += RingMap.ROAD_WIDTH / 2.0
		
		movement_vector = Vector2(next_path_segment.radius - start_ring_vector.radius, next_path_segment.rotation - start_ring_vector.rotation)
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


func update_current_path(new_vector:RingVector):
	current_path = CityNavigator.get_shortest_path(new_vector, pathfinding_target)
	current_segments = [ ]
	
	for segment in range(1, current_path.size()):
		current_segments.append(RingMap.get_ring_position_of_object(current_path[segment].x, current_path[segment].x))
	
	print("current_path: %s\ncurrent_segments: %s" % [current_path, current_segments])




func set_pathfinding_target(new_target:RingVector):
	pathfinding_target = new_target
	update_current_path(pathfinding_target)


func set_start_ring_vector(new_vector:RingVector):
	start_ring_vector = new_vector



func get_pathfinding_target() -> RingVector:
	return pathfinding_target


func get_start_ring_vector() -> RingVector:
	return start_ring_vector
