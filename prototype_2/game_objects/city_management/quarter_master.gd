class_name QuarterMaster, "res://assets/icons/icon_quarter_master.svg"
extends Node


onready var _worker_queue: WorkerQueue = $worker_queue
onready var _job_queue: JobQueue = $job_queue
onready var _resource_sightings: ResourceSightings = $resource_sightings

onready var _update_timer: Timer = $timer

onready var _navigator: Navigator = ServiceLocator.navigator




func _enter_tree():
	ServiceLocator.register_as_quarter_master(self)

func _ready():
	_update_timer.connect("timeout", self, "_assign_job")

func _exit_tree():
	ServiceLocator.unregister_as_quarter_master(self)




func apply_for_job(puppet_master: Node2D, inventory: Inventory, tool_belt: ToolBelt) -> WorkerQueue.WorkerProfile:
	return _worker_queue.add_worker(puppet_master, inventory, tool_belt)

func unapply_for_job(profile: WorkerQueue.WorkerProfile):
	return _worker_queue.remove_worker(profile)


func post_job(city_structure: Node2D, city_pilot_master: Node2D, how_many_workers, request_until_capacity: bool) -> JobQueue.JobPosting:
	return _job_queue.add_job(city_structure, city_pilot_master, how_many_workers, request_until_capacity)

func unpost_job(posting: JobQueue.JobPosting):
	return _job_queue.remove_job(posting)


func register_resource(structure: Node2D, inventory: Inventory, maximum_workers) -> ResourceSightings.ResourceProfile:
	return _resource_sightings.add_resource(structure, inventory, maximum_workers)
	
func unregister_resource(profile: ResourceSightings.ResourceProfile):
	return _resource_sightings.remove_resource(profile)




func _assign_job():
	if _worker_queue.empty() or _job_queue.empty() or _resource_sightings.empty():
		return
	
	var worker_profile: WorkerQueue.WorkerProfile = _worker_queue.pop_front()
	var job_queue: Array = _job_queue.queue
	var puppet_master = worker_profile.puppet_master
	
	
	for job in job_queue:
		var item_in_pocket: GameResource = worker_profile.can_do_job_now(job.get_requests())
		
		if item_in_pocket:
			var resource_profile: ResourceSightings.ResourceProfile = _resource_sightings.resource_registered(item_in_pocket)
			
			job.assign_worker(puppet_master, resource_profile)
			puppet_master.new_plan(job.city_structure, job.city_structure, item_in_pocket.type, item_in_pocket, job)
			print(job)
			return
	
	
	for job in job_queue:
		var errand: WorkerQueue.Errand = worker_profile.can_do_job_eventually(job.get_requests())
		
		if errand:
			var nearest_resource = _navigator.nearest_in_group(puppet_master.global_position, errand.use, [job.city_structure.type])
			
			if nearest_resource:
				var resource_profile: ResourceSightings.ResourceProfile = _resource_sightings.resource_registered(nearest_resource)
				
				job.assign_worker(puppet_master, resource_profile)
				puppet_master.new_plan(job.city_structure, nearest_resource, errand.use, errand.craft_tool, job)
				print(job)
				return
			
			
			var new_quest: Quest = _find_job_target(puppet_master, errand.use, [job.city_structure.type])
			
			if new_quest.target:
				job.assign_worker(puppet_master, new_quest.target_profile)
				puppet_master.new_plan(job.city_structure, new_quest.target, errand.use, errand.craft_tool, job)
				print(job)
				return
	
	
	_worker_queue.requeue(worker_profile)



func _find_job_target(puppet_master: Node2D, job_target_group, groups_to_exclude: Array = [ ]) -> Quest:
	var target: Node2D = null
	var target_profile: ResourceSightings.ResourceProfile = null
	
	var array_of_profiles: Array = _resource_sightings.get_offering(job_target_group)
	var array_to_search: Array = [ ]
	
	
	for profile in array_of_profiles:
		array_to_search.append(profile.structure)
	
	target = _navigator.nearest_from_array(puppet_master.global_position, array_to_search, groups_to_exclude)
	
	for profile in array_of_profiles:
		if profile.structure == target:
			target_profile = profile
			target_profile.assigned_workers.append(puppet_master)
			break
	
	return Quest.new(target, target_profile)





class Quest:
	
	var target: Node2D
	var target_profile: ResourceSightings.ResourceProfile
	
	
	func _init(new_target: Node2D, new_target_profile: ResourceSightings.ResourceProfile):
		target = new_target
		target_profile = new_target_profile
