class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppet_master.svg"
extends Node


export(NodePath) var _hit_box_node
export(NodePath) var _inventory_node
export(NodePath) var _animation_tree_node

export(Constants.Actors) var _behaves_like
#export(Array, Array, Constants.Resources) var behavior_overrides


var pathfinding_target: RingVector
var object_of_interest = null setget set_object_of_interest


var _puppeteer: Puppeteer
var _actor_behavior: ActorBehavior

var _current_path: Array = [ ]
var _current_segments: Array = [ ]

var _path_progress: int = 0

var _update_pathfinding: bool = false
var _update_target: bool = false


onready var _game_actor: GameActor = owner
onready var _hit_box: ActorHitBox = get_node(_hit_box_node)
onready var _animation_tree: AnimationStateMachine = get_node(_animation_tree_node)

onready var _update_tick: int = randi() % 16



func _ready():
	_puppeteer = Puppeteer.new()
	
	_game_actor.connect("entered_segment", self, "_update_path_progress")
	
	_actor_behavior = ActorBehavior.new(_behaves_like, get_node(_inventory_node))
	_actor_behavior.connect("new_object_of_interest", self, "set_object_of_interest")
	
	_actor_behavior.force_search(_game_actor.ring_vector)
	
	RingMap.connect("city_changed", self, "queue_search")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if _update_pathfinding and OS.get_ticks_msec() % 16 == _update_tick:
		_update_current_path()
		_update_pathfinding = false
	
	if _update_target and OS.get_ticks_msec() % 16 == _update_tick:
		_actor_behavior.force_search(_game_actor.ring_vector)
		_update_target = false
	
	if _animation_tree.can_act:
		var commands: Array = _puppeteer.get_input(object_of_interest, _hit_box, _game_actor.ring_vector, _current_segments, _path_progress, _actor_behavior.currently_looking_for)
		
		for command in commands:
			var subject = _game_actor
			
			if command is Puppeteer.InteractCommand or command is InputMaster.MenuCommand:
				subject = _hit_box
				_actor_behavior.force_search(_game_actor.ring_vector)
			
			if command.execute(subject):
				break




func _update_current_path():
	_current_path.clear()
	_current_segments.clear()
	_path_progress = 0
	
	if pathfinding_target:
		var side_of_the_road = CityLayout.ROAD_WIDTH * (0.25 + randf() * 0.5)
		_current_path = RingMap.city_navigator.get_shortest_path(_game_actor.ring_vector, pathfinding_target)
		
		for segment in range(1, _current_path.size()):
			var new_segment = RingVector.new(_current_path[segment].x, _current_path[segment].y, true)
			new_segment.radius += side_of_the_road
			
			_current_segments.append(new_segment)
		
		if object_of_interest:
			_current_segments.append(object_of_interest.ring_vector)
			#print("\n%s:\ncurrent_path: %s\ncurrent_segments: %s\n" % [_game_actor.name, _current_path, _current_segments])


func _update_path_progress(new_vector: RingVector):
	if pathfinding_target:
		_path_progress = int(max(_path_progress, _current_path.find(Vector2(new_vector.ring, new_vector.segment))))


func _queue_update():
	_update_pathfinding = true


func queue_search():
	_update_target = true




func set_object_of_interest(new_object, calculate_pathfinding: bool = true):
	if object_of_interest and calculate_pathfinding:
		object_of_interest.disconnect("died", _actor_behavior, "force_search")
	
	object_of_interest = new_object
	
	if calculate_pathfinding:
		if object_of_interest:
			pathfinding_target = object_of_interest.ring_vector
			object_of_interest.connect("died", _actor_behavior, "force_search", [_game_actor.ring_vector, false])
		else:
			pathfinding_target = null
		
		_queue_update()


func set_actor_type(actor_type: int):
	if not actor_type == _behaves_like:
		_puppeteer = InputMaster.new() if actor_type == Constants.Actors.PLAYER else Puppeteer.new()
		_actor_behavior.set_priorities_from_actor(actor_type)
		_actor_behavior.force_search(_game_actor.ring_vector)



func get_currently_looking_for() -> Dictionary:
	return _actor_behavior.currently_looking_for
