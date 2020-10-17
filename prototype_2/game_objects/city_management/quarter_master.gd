class_name QuarterMaster, "res://assets/icons/icon_quarter_master.svg"
extends Node


onready var _worker_queue: WorkerQueue = $worker_queue
onready var _job_queue: JobQueue = $job_queue
onready var _resource_sightings: ResourceSightings = $resource_sightings

onready var _navigation: Navigation2D = ServiceLocator.navigation




func _enter_tree():
	ServiceLocator.register_as_quarter_master(self)

func _exit_tree():
	ServiceLocator.unregister_as_quarter_master(self)



func _process(_delta):
	_assign_job()




func apply_for_job(puppet_master, inventory: Inventory, tool_belt: ToolBelt) -> WorkerQueue.WorkerProfile:
	return _worker_queue.add_worker(puppet_master, inventory, tool_belt)


func post_job(city_structure, city_pilot_master, how_many_workers, request_until_capacity: bool) -> JobQueue.JobPosting:
	return _job_queue.add_job(city_structure, city_pilot_master, how_many_workers, request_until_capacity)


func register_resource(structure, inventory: Inventory, maximum_workers) -> ResourceSightings.ResourceProfile:
	return _resource_sightings.add_resource(structure, inventory, maximum_workers)




func _assign_job():
	if _worker_queue.empty() or _job_queue.empty():
		return
	
	var worker_profile: WorkerQueue.WorkerProfile = _worker_queue.pop_front()
	var job_queue: Array = _job_queue.queue
	
	var puppet_master = worker_profile.puppet_master
	
	
	for job in job_queue:
		var item_in_pocket: GameResource = worker_profile.can_do_job_now(job.get_requests())
		
		if item_in_pocket:
			puppet_master.new_plan(job.city_structure, job.city_structure, item_in_pocket.type, item_in_pocket, job)
			job.assigned_workers += 1
			
			return
	
	
	for job in job_queue:
		var errand: WorkerQueue.Errand = worker_profile.can_do_job_eventually(job.get_requests())
		
		if errand:
			var task_target: Node2D = _find_job_target(puppet_master.global_position, errand.use, [job.city_structure.type])
			
			puppet_master.new_plan(job.city_structure, task_target, errand.use, errand.craft_tool, job)
			job.assigned_workers += 1
			
			return
	
	
	_worker_queue.requeue(worker_profile)



func _find_job_target(worker_position: Vector2, job_target_group, groups_to_exclude: Array = [ ]) -> Node2D:
	return _navigation._nearest_in_group(worker_position, job_target_group, groups_to_exclude)
