class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppeteer.svg"
extends InputMaster


var pathfinding_target
var object_of_interest = null setget set_object_of_interest


var _current_path: PoolVector2Array = [ ]

var _update_pathfinding: bool = false
var _update_target: bool = false




func _init(new_state_machine: StateMachine).(new_state_machine):
	pass


func _ready():
	pass#_resource_locator.connect("new_object_of_interest", self, "set_object_of_interest")




func process_commands():
	if _update_pathfinding:
		_update_current_path()
		_update_pathfinding = false
	
	while not _current_path.empty() and global_position.distance_to(_current_path[0]) <= 1.0:
		_current_path.remove(0)
	
	.process_commands()



func _get_input() -> Array:
	var commands: Array = [ ]
	
#	if weakref(object_of_interest).get_ref():
#		var hit_box_in_range = hit_box.has_object(object_of_interest)
#
#		if not hit_box_in_range and object_of_interest is GameResource and hit_box.has_inactive_object(object_of_interest):
#			hit_box_in_range = hit_box.has_object(object_of_interest.get_owner())
#
#		if hit_box_in_range:
#			commands.append(InteractCommand.new(hit_box_in_range))
	
	
	var movement_vector: Vector2 = Vector2()
	
	if not _current_path.empty():
		movement_vector = _current_path[0] - global_position
		#print("movement_vector: %s" % [movement_vector])
		
	commands.append(MoveCommand.new(movement_vector))
	
	return commands



func _update_current_path():
	if pathfinding_target:
		_current_path = get_tree().get_root().get_node("test/navigation").get_simple_path(global_position, pathfinding_target)
	else:
		_current_path = PoolVector2Array()
	
	#print("\n%s:\ncurrent_path: %s\n" % [_game_actor.name, _current_path])



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
