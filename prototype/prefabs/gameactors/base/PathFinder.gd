tool
extends PuppetMaster
class_name PathFinder


var ring_map:RingMap setget set_ring_map, get_ring_map

var pathfinding_target:RingVector setget set_pathfinding_target, get_pathfinding_target

var object_of_interest:GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for

var can_act:bool = true setget set_can_act, get_can_act

var current_path:Array = [ ]
var current_segments:Array = [ ]



func _process(_delta):
	if current_actor:
		if object_of_interest:
			if false and can_act:
				interact_with_object(object_of_interest)
		elif currently_searching_for:
			search_for_target(currently_searching_for)



func get_input() -> Array:
	var commands:Array = [ ]
	var movement_vector:Vector2
	var next_path_segment:RingVector = current_segments[0] if not current_segments.empty() else null
	
	if next_path_segment:
		next_path_segment.modulo_ring_vector()
		
		movement_vector = Vector2(next_path_segment.radius - current_actor.ring_vector.radius, next_path_segment.rotation - current_actor.ring_vector.rotation)
		movement_vector.x /= 256
		
		#print("movement_vector: %s" % [movement_vector])
		
		if movement_vector.length() > 0:
			movement_vector = movement_vector.normalized()
		
			commands.append(MoveCommand.new(movement_vector, false))
	else:
		commands.append(MoveCommand.new(Vector2(), false))
	
	return commands


func register_actor(new_actor:GameActor):
	.register_actor(new_actor)
	
	current_actor.connect("entered_segment", self, "update_current_path")
	current_actor.connect("acquired_target", self, "set_currently_searching_for")
	current_actor.connect("can_act_again", self, "set_can_act")


func update_current_path(new_vector:RingVector = current_actor.ring_vector):
	current_path = [ ]
	current_segments = [ ]
	
	if pathfinding_target:
		current_path = ring_map.city_navigator.get_shortest_path(new_vector, pathfinding_target)
		
		for segment in range(1, current_path.size()):
			var new_segment = RingVector.new(current_path[segment].x, current_path[segment].y, true)
			
			new_segment.radius += CityLayout.ROAD_WIDTH / 2.0
			
			current_segments.append(new_segment)
	
	if currently_searching_for and object_of_interest:
		current_segments.append(object_of_interest.ring_vector)
	
	#print("current_path: %s\ncurrent_segments: %s" % [current_path, current_segments])


func search_for_target(object_type:String):
	if not pathfinding_target:
		var nearest_target
		var thing = false
		
		if object_type == CityLayout.TREE:
			thing = true
		
		if thing:
			var nearest_targets = ring_map.city_navigator.get_nearest_thing(current_actor.ring_vector, object_type)
			var shortest_distance = -1
			
			for target in nearest_targets:
				if shortest_distance < 0 or abs(current_actor.ring_vector.rotation - target.ring_vector.rotation) < shortest_distance:
					nearest_target = target
		else:
			nearest_target = ring_map.city_navigator.get_nearest(current_actor.ring_vector, object_type)
		
		if nearest_target:
			set_object_of_interest(nearest_target)
			set_pathfinding_target(nearest_target.ring_vector)


func interact_with_object(object:GameObject = object_of_interest) -> bool:
	var interacted:bool = false
	
	match object.get_class():
		"TreePoint":
			if not object_of_interest.damage(5, get_parent()):
				set_object_of_interest(null)
				interacted = true
		_:
			while not current_actor.inventory.empty():
				object_of_interest.inventory.append(current_actor.inventory.pop_front())
			
			interacted = object_of_interest.interact("", get_parent())
			set_object_of_interest(null)
	
	return interacted




func set_ring_map(new_ring_map:RingMap):
	ring_map = new_ring_map


func set_pathfinding_target(new_target:RingVector):
	pathfinding_target = new_target
	update_current_path()


func set_object_of_interest(new_object:GameObject):
	object_of_interest = new_object
	update_current_path()
	
	current_actor.set_object_of_interest(object_of_interest)


func set_currently_searching_for(new_interest):
	currently_searching_for = new_interest
	update_current_path()


func set_can_act(new_status:bool):
	can_act = new_status



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
