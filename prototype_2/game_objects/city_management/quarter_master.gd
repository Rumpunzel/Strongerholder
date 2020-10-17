class_name QuarterMaster, "res://assets/icons/icon_quarter_master.svg"
extends Node


onready var _worker_queue: WorkerQueue = $worker_queue
onready var _job_queue: JobQueue = $job_queue




func _enter_tree():
	ServiceLocator.register_as_quarter_master(self)

func _exit_tree():
	ServiceLocator.unregister_as_quarter_master(self)



func _process(_delta):
	_assign_job()




func apply_for_job(puppet_master, inventory: Inventory, tool_belt: ToolBelt):
	_worker_queue.add_worker(puppet_master, inventory, tool_belt)


func post_job(city_structure, requested_resources: Array, how_many_workers = 1, request_until_capacity: bool = false):
	_job_queue.add_job(city_structure, requested_resources, how_many_workers, request_until_capacity)




func _assign_job():
	if _worker_queue.empty() or _job_queue.empty():
		return
	
	var worker_profile: WorkerQueue.WorkerProfile = _worker_queue.pop_front()
	var job_queue: Array = _job_queue.get_queue()
	
	var puppet_master = worker_profile.puppet_master
	
	
	for job in job_queue:
		var item_in_pocket: GameResource = worker_profile.can_do_job_now(job.requested_resources)
		
		if item_in_pocket:
			puppet_master.new_plan(job.city_structure, job.city_structure, item_in_pocket.type, item_in_pocket)
			
			job.assigned_workers += 1
			
			return
	
	
	for job in job_queue:
		var errand: WorkerQueue.Errand = worker_profile.can_do_job_eventually(job.requested_resources)
		
		if errand:
			puppet_master.new_plan(job.city_structure, null, errand.use, errand.craft_tool)
			
			job.assigned_workers += 1
			
			return
	
	
	_worker_queue.requeue(worker_profile)
