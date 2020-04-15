class_name PuppetMaster, "res://assets/icons/icon_puppet_master.svg"
extends Node


export(NodePath) var game_actor_node
export(NodePath) var hit_box_node
export(NodePath) var inventory_node
export(NodePath) var animation_tree_node

export(Constants.Actors) var behaves_like
#export(Array, Array, Constants.Resources) var behavior_overrides


var pathfinding_target: RingVector setget set_pathfinding_target, get_pathfinding_target
var object_of_interest = null setget set_object_of_interest, get_object_of_interest


var puppeteer: Puppeteer
var actor_behavior: ActorBehavior

var current_path: Array = [ ]
var current_segments: Array = [ ]

var path_progress: int = 0

var update_pathfinding: bool = false


onready var game_actor = get_node(game_actor_node)
onready var hit_box = get_node(hit_box_node)
onready var animation_tree = get_node(animation_tree_node)




func _ready():
	puppeteer = Puppeteer.new()
	
	game_actor.connect("entered_segment", self, "update_path_progress")
	
	actor_behavior = ActorBehavior.new(behaves_like, get_node(inventory_node))
	actor_behavior.connect("new_object_of_interest", self, "set_object_of_interest")
	
	actor_behavior.force_search(game_actor.ring_vector)
	
	RingMap.connect("city_changed", actor_behavior, "call_deferred", ["force_search", game_actor.ring_vector])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if update_pathfinding:
		call_deferred("update_current_path")
		update_pathfinding = false
	
	if animation_tree.can_act:
		var commands: Array = puppeteer.get_input(object_of_interest, hit_box, game_actor.ring_vector, current_segments, path_progress, actor_behavior)
		
		for command in commands:
			var subject = game_actor
			
			if command is Puppeteer.InteractCommand or command is InputMaster.MenuCommand:
				subject = hit_box
			
			if command.execute(subject):
				break




func update_current_path():
	current_path = [ ]
	current_segments = [ ]
	path_progress = 0
	
	if pathfinding_target:
		var side_of_the_road = CityLayout.ROAD_WIDTH * (0.25 + randf() * 0.5)
		current_path = RingMap.city_navigator.get_shortest_path(game_actor.ring_vector, pathfinding_target)
		
		for segment in range(1, current_path.size()):
			var new_segment = RingVector.new(current_path[segment].x, current_path[segment].y, true)
			new_segment.radius += side_of_the_road
			
			current_segments.append(new_segment)
		
		if object_of_interest:
			current_segments.append(object_of_interest.ring_vector)
			
			#print("\n%s:\ncurrent_path: %s\ncurrent_segments: %s\n" % [game_actor.name, current_path, current_segments])


func update_path_progress(new_vector: RingVector):
	if pathfinding_target:
		path_progress = int(max(path_progress, current_path.find(Vector2(new_vector.ring, new_vector.segment))))


func queue_update():
	update_pathfinding = true




func set_pathfinding_target(new_target: RingVector):
	pathfinding_target = new_target


func set_object_of_interest(new_object, calculate_pathfinding: bool = true):
	if object_of_interest and calculate_pathfinding:
		object_of_interest.disconnect("died", actor_behavior, "force_search")
	
	object_of_interest = new_object
	
	if calculate_pathfinding:
		if object_of_interest:
			pathfinding_target = object_of_interest.ring_vector
			object_of_interest.connect("died", actor_behavior, "force_search", [game_actor.ring_vector, false])
		else:
			pathfinding_target = null
		
		queue_update()


func set_actor_type(actor_type: int):
	if not actor_type == behaves_like:
		puppeteer = InputMaster.new() if actor_type == Constants.Actors.PLAYER else Puppeteer.new()
		actor_behavior.set_priorities(actor_type)
		actor_behavior.force_search(game_actor.ring_vector)




func get_pathfinding_target() -> RingVector:
	return pathfinding_target

func get_object_of_interest():
	return object_of_interest

func get_currently_looking_for() -> int:
	return actor_behavior.currently_looking_for
