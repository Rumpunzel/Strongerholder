tool
extends PuppetMaster
class_name PathFinder


var ring_map:RingMap setget set_ring_map, get_ring_map

var start_ring_vector:RingVector setget set_start_ring_vector, get_start_ring_vector
var pathfinding_target:RingVector setget set_pathfinding_target, get_pathfinding_target
var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest

var current_path:Array = [ ]
var current_segments:Array = [ ]



func get_input() -> Array:
	var commands:Array = [ ]
	var movement_vector:Vector2
	var next_path_segment:RingVector = current_segments[0] if not current_segments.empty() else null
	
	if next_path_segment:
		next_path_segment.modulo_ring_vector()
		
		movement_vector = Vector2(next_path_segment.radius - start_ring_vector.radius, next_path_segment.rotation - start_ring_vector.rotation)
		movement_vector.x /= 256
		
		#print("movement_vector: %s" % [movement_vector])
		
		if movement_vector.length() > 0:
			movement_vector = movement_vector.normalized()
		
			commands.append(MoveCommand.new(movement_vector, false))
	else:
		commands.append(MoveCommand.new(Vector2(), false))
	
	return commands


func register_actor(new_actor:GameActor, exclusive_actor:bool = true):
	.register_actor(new_actor, exclusive_actor)
	
	set_start_ring_vector(new_actor.ring_vector)
	
	new_actor.connect("moved", self, "set_start_ring_vector")
	new_actor.connect("entered_segment", self, "update_current_path")


func update_current_path(new_vector:RingVector):
	current_path = [ ]
	current_segments = [ ]
	
	if start_ring_vector and pathfinding_target:
		current_path = ring_map.city_navigator.get_shortest_path(new_vector, pathfinding_target)
		
		for segment in range(1, current_path.size()):
			var new_segment = RingVector.new(current_path[segment].x, current_path[segment].y, true)
			
			new_segment.radius += CityLayout.ROAD_WIDTH / 2.0
			
			current_segments.append(new_segment)
	
	if object_of_interest:
		current_segments.append(object_of_interest.ring_vector)
	
	#print("current_path: %s\ncurrent_segments: %s" % [current_path, current_segments])



func set_ring_map(new_ring_map:RingMap):
	ring_map = new_ring_map


func set_pathfinding_target(new_target:RingVector):
	pathfinding_target = new_target
	update_current_path(start_ring_vector)


func set_start_ring_vector(new_vector:RingVector):
	start_ring_vector = new_vector


func set_object_of_interest(new_object:GameObject):
	object_of_interest = new_object
	update_current_path(start_ring_vector)



func get_ring_map() -> RingMap:
	return ring_map


func get_pathfinding_target() -> RingVector:
	return pathfinding_target


func get_start_ring_vector() -> RingVector:
	return start_ring_vector


func get_object_of_interest() -> GameObject:
	return object_of_interest
