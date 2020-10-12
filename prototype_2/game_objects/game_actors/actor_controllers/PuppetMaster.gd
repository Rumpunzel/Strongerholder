class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppet_master.svg"
extends Node2D


export(NodePath) var _hit_box_node
export(NodePath) var _resource_locator_node
export(NodePath) var _animation_tree_node


var pathfinding_target
var object_of_interest = null setget set_object_of_interest


var _puppeteer: Puppeteer

var _current_path: PoolVector2Array = [ ]

var _update_pathfinding: bool = false
var _update_target: bool = false


onready var _game_actor: GameActor = owner
onready var _hit_box: ActorHitBox = get_node(_hit_box_node)
onready var _resource_locator = get_node(_resource_locator_node)
onready var _animation_tree: AnimationStateMachine = get_node(_animation_tree_node)



func _ready():
	_puppeteer = Puppeteer.new()
	
	_resource_locator.connect("new_object_of_interest", self, "set_object_of_interest")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if _update_pathfinding:
		_update_current_path()
		_update_pathfinding = false
	
	
	if _animation_tree.can_act:
		_process_commands()




func _process_commands():
	while not _current_path.empty() and global_position.distance_to(_current_path[0]) <= 1.0:
		_current_path.remove(0)
	
	var commands: Array = _puppeteer.get_input(object_of_interest, _hit_box, global_position, _current_path)
	
	for command in commands:
		var subject = _game_actor
		
		if command is Puppeteer.InteractCommand or command is InputMaster.MenuCommand:
			subject = _hit_box
		
		if command.execute(subject):
			break



func _update_current_path():
	if pathfinding_target:
		_current_path = get_tree().get_root().get_node("test/navigation").get_simple_path(global_position, pathfinding_target)
		#_current_path.remove(0)
	else:
		_current_path = PoolVector2Array()
	
	print("\n%s:\ncurrent_path: %s\n" % [_game_actor.name, _current_path])



func _queue_update():
	_update_pathfinding = true


func queue_search():
	_update_target = true




func set_object_of_interest(new_object, calculate_pathfinding: bool = true):
	object_of_interest = new_object
	
	if calculate_pathfinding:
		if object_of_interest:
			pathfinding_target = object_of_interest.global_position
		else:
			pathfinding_target = null
		
		_queue_update()


func set_player_controlled(new_status: bool):
	_puppeteer = InputMaster.new() if new_status else Puppeteer.new()



func is_player_controlled():
	return _puppeteer is InputMaster
