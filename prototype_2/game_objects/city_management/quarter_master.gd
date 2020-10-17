class_name QuarterMaster, "res://assets/icons/icon_quarter_master.svg"
extends Node


onready var _worker_queue: WorkerQueue = $worker_queue
onready var _job_queue: JobQueue = $job_queue

onready var _navigation: Navigation2D = ServiceLocator.navigation




func _enter_tree():
	ServiceLocator.register_as_quarter_master(self)

func _exit_tree():
	ServiceLocator.unregister_as_quarter_master(self)



func _process(_delta):
	pass#_assign_job()




func apply_for_job(game_actor: PuppetMaster, inventory: Inventory, tool_belt: ToolBelt):
	_worker_queue.add_worker(game_actor, inventory, tool_belt)


func post_job(city_structure, requested_resources: Array, how_many_workers = 1, request_until_capacity: bool = false):
	_job_queue.add_job(city_structure, requested_resources, how_many_workers, request_until_capacity)




func _assign_job():
	if _worker_queue.empty() or _job_queue.empty():
		return
	
	var worker_profile: WorkerQueue.WorkerProfile = _worker_queue.pop_front()
	var job_queue: Array = _job_queue.get_queue()
	
	var game_actor: PuppetMaster = worker_profile.game_actor
	
	
	for job in job_queue:
		var item_in_pocket: GameResource = worker_profile.can_do_job_now(job.requested_resources)
		
		if item_in_pocket:
			game_actor.new_plan(job.city_structure, job.city_structure, item_in_pocket.type, item_in_pocket)
			
			job.assigned_workers += 1
			
			return
	
	
	for job in job_queue:
		var errand: WorkerQueue.Errand = worker_profile.can_do_job_eventually(job.requested_resources)
		
		if errand:
			game_actor.new_plan(job.city_structure, null, errand.use, errand.craft_tool)
			
			job.assigned_workers += 1
			
			return
	
	
	_worker_queue.requeue(worker_profile)





func get_task(global_position: Vector2, inventory_contents: Array, available_tools: Array) -> Dictionary:
	for item in inventory_contents:
		var item_type: String = Constants.enum_name(Constants.Resources, item.type)
		var nearest_master: Node2D = _nearest_in_group(global_position, "%s%s" % [Constants.REQUEST, item_type])
		
		if nearest_master:
			return { PuppetMaster.TASK_MASTER: nearest_master, PuppetMaster.TASK_TARGET: nearest_master, PuppetMaster.PURPOSE: item.type, PuppetMaster.TOOL: item }
	
	
	for craft_tool in available_tools:
		for use in craft_tool.used_for:
			var tool_type: String = Constants.enum_name(Constants.Resources, use)
			var nearest_master: Node2D = _nearest_in_group(global_position, "%s%s" % [Constants.REQUEST, tool_type])
			
			if nearest_master:
				return { PuppetMaster.TASK_MASTER: nearest_master, PuppetMaster.PURPOSE: use, PuppetMaster.TOOL: craft_tool }
	
	return { }



func search_task_target(global_position: Vector2, task_master: Node2D, purpose) -> Node2D:
	return _nearest_in_group(global_position, purpose, [ task_master.type ])




func _nearest_in_group(global_position: Vector2, group_name, groups_to_exclude: Array = [ ]) -> Node2D:
	if Constants.is_structure(group_name) or Constants.is_thing(group_name):
		group_name = Constants.enum_name(Constants.Structures, group_name)
	elif Constants.is_resource(group_name):
		group_name = Constants.enum_name(Constants.Resources, group_name)
	
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
