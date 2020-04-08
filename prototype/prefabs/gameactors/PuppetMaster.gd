class_name PuppetMaster
extends Node


signal new_commands(commands)


var ring_map: RingMap setget set_ring_map, get_ring_map

var pathfinding_target: RingVector setget set_pathfinding_target, get_pathfinding_target

var object_of_interest: GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for

var update_pathfinding: bool = false setget set_update_pathfinding, get_update_pathfinding


var current_actor: GameActor = null
var current_path: Array = [ ]
var current_segments: Array = [ ]
var path_progress: int = 0




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if current_actor:
		if not object_of_interest and currently_searching_for:
			search_for_target(currently_searching_for)
	
	if update_pathfinding:
		update_current_path()
		update_pathfinding = false
	
	
	var commands: Array = get_input()
	
	if not commands.empty():
		emit_signal("new_commands", commands)




func get_input() -> Array:
	var commands: Array = [ ]
	
	if object_of_interest and not currently_searching_for:
		commands.append(InteractCommand.new(object_of_interest))
	
	
	var movement_vector: Vector3 = Vector3()
	var next_path_segment: RingVector = current_segments[path_progress] if path_progress < current_segments.size() else null
	
	if next_path_segment:
		next_path_segment.modulo_ring_vector()
		
		var rotation_change = next_path_segment.rotation - current_actor.ring_vector.rotation
		
		while rotation_change > PI:
			rotation_change -= TAU
	
		while rotation_change < -PI:
			rotation_change += TAU
		
		movement_vector = Vector3(next_path_segment.radius - current_actor.ring_vector.radius, 0, rotation_change)
		
		movement_vector.z *= next_path_segment.radius
		
		#print("movement_vector: %s" % [movement_vector])
	
	commands.append(MoveCommand.new(movement_vector))
	
	return commands




func register_actor(new_actor: GameActor):
	current_actor = new_actor
	
	connect("new_commands", current_actor, "listen_to_commands")
	
	current_actor.connect("entered_segment", self, "update_path_progress")
	current_actor.connect("acquired_target", self, "set_currently_searching_for")


func update_current_path():
	current_path = [ ]
	current_segments = [ ]
	path_progress = 0
	
	if pathfinding_target:
		var side_of_the_road = CityLayout.ROAD_WIDTH * (0.25 + randf() * 0.5)
		current_path = ring_map.city_navigator.get_shortest_path(current_actor.ring_vector, pathfinding_target)
		
		for segment in range(1, current_path.size()):
			var new_segment = RingVector.new(current_path[segment].x, current_path[segment].y, true)
			
			new_segment.radius += side_of_the_road
			
			current_segments.append(new_segment)
	
	if currently_searching_for and object_of_interest:
		current_segments.append(object_of_interest.ring_vector)
		
		#print("\n%s:\ncurrent_path: %s\ncurrent_segments: %s\n" % [current_actor.name, current_path, current_segments])


func update_path_progress(new_vector: RingVector):
	var new_progress = current_path.find(Vector2(new_vector.ring, new_vector.segment))
	
	if new_progress > 0:
		path_progress = int(max(path_progress, new_progress))
	else:
		update_current_path()



func search_for_target(object_type: int):
	var nearest_target
	var thing = false
	
	if object_type == CityLayout.Objects.TREE:
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


func reset_object_of_interest(old_object: GameObject):
	if object_of_interest == old_object:
		set_object_of_interest(null)




func set_ring_map(new_ring_map: RingMap):
	ring_map = new_ring_map

func set_pathfinding_target(new_target: RingVector):
	pathfinding_target = new_target


func set_object_of_interest(new_object: GameObject):
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


func set_update_pathfinding(new_status: bool):
	update_pathfinding = new_status



func get_ring_map() -> RingMap:
	return ring_map

func get_pathfinding_target() -> RingVector:
	return pathfinding_target

func get_object_of_interest() -> GameObject:
	return object_of_interest

func get_currently_searching_for():
	return currently_searching_for

func get_update_pathfinding() -> bool:
	return update_pathfinding




class Command:
	func execute(actor: GameActor) -> bool:
		if actor.can_act():
			return parse_command(actor)
		else:
			return false
	
	func parse_command(_actor: GameActor) -> bool:
		return false



class MoveCommand extends Command:
	var movement_vector: Vector3
	var sprinting: bool
	
	func _init(new_movement_vector: Vector3, new_sprinting: bool = false):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func parse_command(actor: GameActor) -> bool:
		actor.move_to(movement_vector, sprinting)
		return false



class InteractCommand extends Command:
	const INTERACTION: String = "interaction"
	const PARAMETERS: String = "parameters"
	
	const BASIC_INTERACTION: Dictionary = { INTERACTION: GameObject.INTERACT_FUNCTION }
	
	
	var object: GameObject
	
	
	func _init(new_object: GameObject = null):
		object = new_object
	
	
	func parse_command(actor: GameActor) -> bool:
		if not object:
			object = actor.object_of_interest
			
		var interaction: Dictionary = interaction_with(actor)
		
		var function = interaction.get(INTERACTION)
		var parameters: Array = interaction.get(PARAMETERS, [ ])
		
		parameters.append(actor)
		
		if function:
			return object.callv(function, parameters)
		
		return false
	
	
	func interaction_with(actor: GameActor) -> Dictionary:
		if object:
			var interaction: Dictionary = BASIC_INTERACTION
			var animation: String = "give"
			
			match object.type:
				CityLayout.Objects.TREE:
					animation = "attack"
					interaction = { INTERACTION: GameObject.DAMAGE_FUNCTION, PARAMETERS: [ 2.0, 0.3 ] }
				
				CityLayout.Objects.STOCKPILE:
					if not actor.inventory.empty():
						interaction = { INTERACTION: GameObject.GIVE_FUNCTION, PARAMETERS: [ actor.inventory ] }
					else:
						return { }
			
			actor.animate(animation)
			
			return interaction
		
		return { }
