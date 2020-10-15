class_name PuppetMaster, "res://assets/icons/game_actors/icon_puppeteer.svg"
extends InputMaster


var task_master = null
var task_target = null
var task_location = null


var _current_path: PoolVector2Array = [ ]


onready var _inventory: Inventory = $inventory
onready var _tool_belt: ToolBelt = $tool_belt

onready var _navigation: Navigation2D = get_tree().get_root().get_node("test/navigation")




func _ready():
	pass#_resource_locator.connect("new_object_of_interest", self, "set_object_of_interest")



func _process(_delta: float):
	_keep_busy()




func process_commands(state_machine: StateMachine):
	while not _current_path.empty() and global_position.distance_to(_current_path[0]) <= 1.0:
		_current_path.remove(0)
	
	.process_commands(state_machine)



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
	else:
		task_location = null
		
	commands.append(MoveCommand.new(movement_vector))
	
	return commands




func _keep_busy():
	# Having a valid pathfinding location has first priority and counts as being busy
	if task_location:
		return
	
	# Second priority is having a taskmaster whom to work for
	if not task_master:
		_search_task_master()
	
	if task_master and not task_target:
		_search_task_target()



func _search_task_master():
	var services: Array = [ ]
	
	services += _inventory.get_contents() + _tool_belt.get_valid_targets()
	
	
	for service in services:
		task_master = _nearest_in_group("%s%s" % [Constants.REQUEST, service])



func _search_task_target():
	for group in task_master.get_groups():
		if group.begins_with(Constants.REQUEST):
			var request: String = group.trim_prefix(Constants.REQUEST)
			
			if _inventory.has(group):
				task_target = task_master
				break
			elif _tool_belt.get_valid_targets().has(request):
				task_target = _nearest_in_group(request, [task_master.type])
				
				if task_target:
					_update_current_path()
					break



func _nearest_in_group(group_name: String, groups_to_exclude: Array = [ ]) -> Object:
	var group: Array = get_tree().get_nodes_in_group(group_name)
	var nearest_object: Object = null
	var shortest_distance: float = INF
	
	# Check that the potential target's type is actually requested
	for object in group:
		var valid_object: bool = true
		var object_groups: Array = object.get_groups()
		
		for ex_group in groups_to_exclude:
			if object_groups.has(Constants.enum_name(Constants.Structures, ex_group)):
				valid_object = false
				break
		
		if not valid_object:
			continue
		
		# Check if the potential target is the nearest one
		var simple_path: PoolVector2Array = _navigation.get_simple_path(global_position, object.global_position)
		var distance_to_body: float = 0.0
		var path_index: int = 0
		
		while path_index < simple_path.size() - 1:
			distance_to_body += simple_path[path_index].distance_to(simple_path[path_index + 1])
			path_index += 1
		
		if distance_to_body < shortest_distance:
			shortest_distance = distance_to_body
			nearest_object = object
	
	return nearest_object



func _update_current_path():
	var target = null
	
	if task_location:
		target = task_location
	elif task_target:
		target = task_target.global_position
	
	if target:
		_current_path = _navigation.get_simple_path(global_position, target)
	else:
		_current_path = PoolVector2Array()
	
	print("\n%s:\ncurrent_path: %s\n" % [owner.name, _current_path])



#func set_object_of_interest(new_object, calculate_pathfinding: bool = true):
#	object_of_interest = new_object
#
#	if calculate_pathfinding:
#		if object_of_interest:
#			pathfinding_target = object_of_interest.global_position
#		else:
#			pathfinding_target = null
#
#		_queue_update()
