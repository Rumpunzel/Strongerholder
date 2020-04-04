extends PuppetMaster
class_name PathFinder


var ring_map:RingMap setget set_ring_map, get_ring_map

var current_actor:GameActor = null

var pathfinding_target:RingVector setget set_pathfinding_target, get_pathfinding_target

var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for

var can_act:bool = true setget set_can_act, get_can_act

var current_path:Array = [ ]
var current_segments:Array = [ ]
var path_progress:int = 0

var update_pathfinding:bool = false setget set_update_pathfinding, get_update_pathfinding



func _process(_delta):
	if current_actor:
		if not object_of_interest and currently_searching_for:
			search_for_target(currently_searching_for)
	
	if update_pathfinding:
		update_current_path()
		update_pathfinding = false



func get_input() -> Array:
	var commands:Array = [ ]
	
	if object_of_interest and not currently_searching_for:
		commands.append(InteractCommand.new(object_of_interest, 1.0))
	
	
	var movement_vector:Vector3 = Vector3()
	var next_path_segment:RingVector = current_segments[path_progress] if path_progress < current_segments.size() else null
	
	if next_path_segment:
		next_path_segment.modulo_ring_vector()
		
		movement_vector = Vector3(next_path_segment.radius - current_actor.ring_vector.radius, 0, next_path_segment.rotation - current_actor.ring_vector.rotation)
		
		movement_vector.z *= next_path_segment.radius
		
		#print("movement_vector: %s" % [movement_vector])
		
		if movement_vector.length() > 0:
			commands.append(MoveCommand.new(movement_vector, false))
	else:
		commands.append(MoveCommand.new(Vector3(), false))
	
	
	return commands


func register_actor(new_actor:GameActor):
	current_actor = new_actor
	
	connect("new_commands", current_actor, "listen_to_commands")
	
	current_actor.connect("entered_segment", self, "update_path_progress")
	current_actor.connect("acquired_target", self, "set_currently_searching_for")
	current_actor.connect("can_act_again", self, "set_can_act")


func update_current_path():
	current_path = [ ]
	current_segments = [ ]
	path_progress = 0
	
	if pathfinding_target:
		current_path = ring_map.city_navigator.get_shortest_path(current_actor.ring_vector, pathfinding_target)
		
		for segment in range(1, current_path.size()):
#			var coming_from_outside:bool = current_path[segment - 1].x > current_path[segment].x
#			var ring_offset:int = 1 if coming_from_outside else 0
			var new_segment = RingVector.new(current_path[segment].x, current_path[segment].y, true)
			
			new_segment.radius += CityLayout.ROAD_WIDTH / 2.0
			
			current_segments.append(new_segment)
	
	if currently_searching_for and object_of_interest:
		current_segments.append(object_of_interest.ring_vector)
	
	print("current_path: %s\ncurrent_segments: %s" % [current_path, current_segments])


func update_path_progress(new_vector:RingVector):
	path_progress = int(max(path_progress, current_path.find(Vector2(new_vector.ring, new_vector.segment))))



func search_for_target(object_type:String):
	var nearest_target
	var thing = false
	
	if object_type == CityLayout.TREE:
		thing = true
	
	if thing:
		var nearest_targets = ring_map.city_navigator.get_nearest_thing(current_actor.ring_vector, object_type)
		var shortest_distance = -1
		
		for target in nearest_targets:
			var distance = abs(current_actor.ring_vector.rotation - target.ring_vector.rotation)
			
			if shortest_distance < 0 or distance < shortest_distance:
				nearest_target = target
				shortest_distance = distance
	else:
		nearest_target = ring_map.city_navigator.get_nearest(current_actor.ring_vector, object_type)
	
	if nearest_target:
		pathfinding_target = nearest_target.ring_vector
		set_object_of_interest(nearest_target)


func reset_object_of_interest(old_object:GameObject):
	if object_of_interest == old_object:
		set_object_of_interest(null)




func set_ring_map(new_ring_map:RingMap):
	ring_map = new_ring_map


func set_pathfinding_target(new_target:RingVector):
	pathfinding_target = new_target


func set_object_of_interest(new_object:GameObject):
	if object_of_interest:
		object_of_interest.disconnect("died", self, "reset_object_of_interest")
	
	object_of_interest = new_object
	update_pathfinding = true
	
	if object_of_interest:
		object_of_interest.connect("died", self, "reset_object_of_interest", [object_of_interest])
	
	current_actor.set_object_of_interest(object_of_interest)


func set_currently_searching_for(new_interest):
	currently_searching_for = new_interest
	
	if new_interest:
		reset_object_of_interest(object_of_interest)
	else:
		update_pathfinding = true


func set_can_act(new_status:bool):
	can_act = new_status


func set_update_pathfinding(new_status:bool):
	update_pathfinding = new_status



func get_ring_map() -> RingMap:
	return ring_map


func get_pathfinding_target() -> RingVector:
	return pathfinding_target


func get_object_of_interest() -> GameObject:
	return object_of_interest


func get_currently_searching_for():
	return currently_searching_for


func get_can_act() -> bool:
	return can_act


func get_update_pathfinding() -> bool:
	return update_pathfinding
