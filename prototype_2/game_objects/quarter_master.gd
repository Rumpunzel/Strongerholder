class_name QuarterMaster, "res://assets/icons/icon_quarter_master.svg"
extends Node


var _worker_queue: Array = [ ]
var _job_queue: Array = [ ]


onready var _navigator: Navigator = ServiceLocator.navigator




func _enter_tree():
	ServiceLocator.register_as_quarter_master(self)


func _exit_tree():
	ServiceLocator.unregister_as_quarter_master(self)




func register_for_job(game_actor: GameActor):
	_worker_queue.append(game_actor)



func get_task(global_position: Vector2, inventory_contents: Array, available_tools: Array) -> Dictionary:
	for item in inventory_contents:
		var item_type: String = Constants.enum_name(Constants.Resources, item.type)
		var nearest_master: Node2D = _nearest_in_group(global_position, "%s%s" % [Constants.REQUEST, item_type])
		
		if nearest_master:
			return { PuppetMaster.TASK_MASTER: nearest_master, PuppetMaster.TASK_TARGET: nearest_master, PuppetMaster.PURPOSE: item_type, PuppetMaster.TOOL: item }
	
	
	for craft_tool in available_tools:
		for use in craft_tool.used_for:
			var tool_type: String = Constants.enum_name(Constants.Resources, use)
			var nearest_master: Node2D = _nearest_in_group(global_position, "%s%s" % [Constants.REQUEST, tool_type])
			
			if nearest_master:
				return { PuppetMaster.TASK_MASTER: nearest_master, PuppetMaster.PURPOSE: tool_type, PuppetMaster.TOOL: craft_tool }
	
	return { }



func search_task_target(global_position: Vector2, task_master: Node2D, purpose: String) -> Node2D:
	return _nearest_in_group(global_position, purpose, [ task_master.type ])




func _nearest_in_group(global_position: Vector2, group_name: String, groups_to_exclude: Array = [ ]) -> Node2D:
	var group: Array = get_tree().get_nodes_in_group(group_name)
	var nearest_object: Node2D = null
	var shortest_distance: float = INF
	
	# Check that the potential target's type is actually requested
	for object in group:
		if not object.is_active():
			continue
		
		var valid_object: bool = true
		var object_groups: Array = object.get_groups()
		
		for ex_group in groups_to_exclude:
			if object_groups.has(Constants.enum_name(Constants.Structures, ex_group)):
				valid_object = false
				break
		
		if not valid_object:
			continue
		
		# Check if the potential target is the nearest one
		var simple_path: PoolVector2Array = _navigator.get_simple_path(global_position, object.global_position)
		var distance_to_body: float = 0.0
		var path_index: int = 0
		
		while path_index < simple_path.size() - 1:
			distance_to_body += simple_path[path_index].distance_to(simple_path[path_index + 1])
			path_index += 1
		
		if distance_to_body < shortest_distance:
			shortest_distance = distance_to_body
			nearest_object = object
	
	return nearest_object
