class_name PuppetMaster
extends Node


signal new_commands(commands)
signal looking_for_target(nothing)


var pathfinding_target: RingVector setget set_pathfinding_target, get_pathfinding_target
var object_of_interest: GameObject = null setget set_object_of_interest, get_object_of_interest


var ring_map: RingMap
var actor_behavior: ActorBehavior

var current_actor = null

var current_path: Array = [ ]
var current_segments: Array = [ ]

var path_progress: int = 0

var update_target: bool = false
var update_pathfinding: bool = false




func _init(new_ring_map: RingMap, new_actor = null):
	ring_map = new_ring_map
	
	if new_actor:
		register_actor(new_actor)
		
		actor_behavior = ActorBehavior.new(current_actor, ring_map)
		
		actor_behavior.connect("new_object_of_interest", self, "set_object_of_interest")
		connect("looking_for_target", self, "queue_update")
		
		queue_search()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if update_target:
		actor_behavior.force_search()
		update_target = false
	
	if update_pathfinding:
		update_current_path()
		update_pathfinding = false
	
	
	var commands: Array = get_input()
	
	if not commands.empty():
		emit_signal("new_commands", commands)




func get_input() -> Array:
	var commands: Array = [ ]
	
	if current_actor.is_in_range(object_of_interest):
		commands.append(InteractCommand.new(object_of_interest))
		queue_search()
	
	
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




func register_actor(new_actor):
	if not new_actor == current_actor:
		unregister_actor(current_actor)
		
		current_actor = new_actor
		
		connect("new_commands", current_actor, "listen_to_commands")
		current_actor.connect("entered_segment", self, "update_path_progress")


func unregister_actor(old_actor):
	if current_actor and old_actor == current_actor:
		disconnect("new_commands", current_actor, "listen_to_commands")
		current_actor.disconnect("entered_segment", self, "update_path_progress")


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
		
		if object_of_interest:
			current_segments.append(object_of_interest.ring_vector)
			
			print("\n%s:\ncurrent_path: %s\ncurrent_segments: %s\n" % [current_actor.name, current_path, current_segments])


func update_path_progress(new_vector: RingVector):
	var new_progress = current_path.find(Vector2(new_vector.ring, new_vector.segment))
	
	if new_progress > 0:
		path_progress = int(max(path_progress, new_progress))
	else:
		queue_update()


func queue_search():
	update_target = true

func queue_update():
	update_pathfinding = true




func set_pathfinding_target(new_target: RingVector):
	pathfinding_target = new_target


func set_object_of_interest(new_object: GameObject, calculate_pathfinding: bool = true):
	if not new_object == object_of_interest:
		if object_of_interest and calculate_pathfinding:
			object_of_interest.disconnect("died", self, "queue_search")
		
		object_of_interest = new_object
		
		if calculate_pathfinding:
			if object_of_interest:
				pathfinding_target = object_of_interest.ring_vector
				object_of_interest.connect("died", self, "queue_search")
			else:
				pathfinding_target = null
				emit_signal("looking_for_target")
			
			queue_update()




func get_pathfinding_target() -> RingVector:
	return pathfinding_target

func get_object_of_interest() -> GameObject:
	return object_of_interest




class Command:
	func execute(actor) -> bool:
		if actor.can_act():
			return parse_command(actor)
		else:
			return false
	
	func parse_command(_actor) -> bool:
		assert(false)
		return false



class MoveCommand extends Command:
	var movement_vector: Vector3
	var sprinting: bool
	
	func _init(new_movement_vector: Vector3, new_sprinting: bool = false):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func parse_command(actor) -> bool:
		actor.move_to(movement_vector, sprinting)
		return false



class InteractCommand extends Command:
	const INTERACTION: String = "interaction"
	const PARAMETERS: String = "parameters"
	
	const BASIC_INTERACTION: Dictionary = { INTERACTION: GameObject.INTERACT_FUNCTION }
	
	
	var object: GameObject
	
	
	func _init(new_object: GameObject):
		object = new_object
	
	
	func parse_command(actor) -> bool:
		var interaction: Dictionary = interaction_with(actor)
		
		var function = interaction.get(INTERACTION)
		var parameters: Array = interaction.get(PARAMETERS, [ ])
		
		parameters.append(actor)
		
		if function:
			return object.callv(function, parameters)
		
		return false
	
	
	func interaction_with(actor, interaction: Dictionary = BASIC_INTERACTION, animation: String = "") -> Dictionary:
		if object:
			if animation == "":
				if object.type == Constants.Objects.TREE:
					animation = "attack"
					interaction = { INTERACTION: GameObject.DAMAGE_FUNCTION, PARAMETERS: [ 2.0, 0.3 ] }
				elif object.type >= Constants.BUILDINGS:
					if not actor.inventory.empty():
						animation = "give"
						interaction = { INTERACTION: GameObject.GIVE_FUNCTION, PARAMETERS: [ actor.inventory ] }
					else:
						return { }
			
			if animation.length() > 0:
				actor.animate(animation)
			
			return interaction
		
		return { }