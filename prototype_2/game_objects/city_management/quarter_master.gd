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
	
	var application_queue: Array = _worker_queue.queue
	
	for job_posting in _job_queue.queue:
		var job_requests: Array = job_posting.get_requests()
		
		_assign_job_to_workers_carrying_the_resource(application_queue, job_posting, job_requests)
		
		if not job_posting.posting_active():
			continue
		
		_assign_job_to_workers_able_to_acquire_the_resource(application_queue, job_posting, job_requests)



func _assign_job_to_workers_carrying_the_resource(application_queue: Array, job_posting: JobQueue.JobPosting, job_requests: Array):
	var relevant_workers: Dictionary = { }
	
	# First check for any workers currently carrying the desired resources
	for worker_profile in application_queue:
		var item_in_pocket: GameResource = worker_profile.can_do_job_now(job_requests)
		
		if item_in_pocket:
			relevant_workers[worker_profile] = item_in_pocket
	
	
	# Then assign workers until the posting is full or all of the workers have been checked
	while job_posting.posting_active() and not relevant_workers.empty():
		var nearest_worker: WorkerQueue.WorkerProfile = _find_nearest_worker(job_posting.city_structure.global_position, relevant_workers.keys())
		var item_in_pocket: GameResource = relevant_workers[nearest_worker]
		
		relevant_workers.erase(nearest_worker)
		
		var puppet_master: Node2D = nearest_worker.puppet_master
		var resource_profile: ResourceSightings.ResourceProfile = _resource_sightings.resource_registered(item_in_pocket)
		
		if not resource_profile.position_open():
			continue
		
		job_posting.assign_worker(puppet_master, resource_profile)
		puppet_master.new_plan(job_posting.city_structure, job_posting.city_structure, item_in_pocket.type, item_in_pocket, job_posting)



func _assign_job_to_workers_able_to_acquire_the_resource(application_queue: Array, job_posting: JobQueue.JobPosting, job_requests: Array):
	var relevant_workers: Dictionary = { }
	
	# Then check for any workers able to acquire the desired resources
	for worker_profile in application_queue:
		var errand: WorkerQueue.Errand = worker_profile.can_do_job_eventually(job_requests)
		
		if errand:
			relevant_workers[worker_profile] = errand
	
	
	var nearest_errands: Dictionary = { }
	
	for errand in relevant_workers.values():
		if nearest_errands.get(errand):
			continue
		
		nearest_errands[errand.use] = _navigator.nearest_in_group(job_posting.city_structure.global_position, errand.use, [job_posting.city_structure.type])
	
	var assigned_errands: Array = [ ]
	
	while job_posting.posting_active() and not relevant_workers.empty():
		for errand in relevant_workers.values():
			var nearest_resource: Node2D = nearest_errands[errand.use]
			
			if nearest_resource:
				var nearest_worker: WorkerQueue.WorkerProfile = _find_nearest_worker(nearest_resource.global_position, relevant_workers.keys())
				var nearest_errand: WorkerQueue.Errand = relevant_workers[nearest_worker]
				
				relevant_workers.erase(nearest_worker)
				
				var puppet_master: Node2D = nearest_worker.puppet_master
				var resource_profile: ResourceSightings.ResourceProfile = _resource_sightings.resource_registered(nearest_resource)
				
				if not resource_profile.posting_active():
					continue
				
				assigned_errands.append(nearest_resource)
				job_posting.assign_worker(puppet_master, resource_profile)
				puppet_master.new_plan(job_posting.city_structure, nearest_resource, nearest_errand.use, nearest_errand.craft_tool, job_posting)
			else:
				var nearest_worker: WorkerQueue.WorkerProfile = _find_nearest_worker(job_posting.city_structure.global_position, relevant_workers.keys())
				var puppet_master: Node2D = nearest_worker.puppet_master
				var nearest_errand: WorkerQueue.Errand = relevant_workers[nearest_worker]
				var new_quest: Quest = _find_job_target(puppet_master, nearest_errand.use, [job_posting.city_structure.type])
				
				relevant_workers.erase(nearest_worker)
				
				if not new_quest.target:
					continue
				
				assigned_errands.append(nearest_resource)
				job_posting.assign_worker(puppet_master, new_quest.target_profile)
				puppet_master.new_plan(job_posting.city_structure, new_quest.target, nearest_errand.use, nearest_errand.craft_tool, job_posting)
			
			nearest_errands[errand.use] = _navigator.nearest_in_group(job_posting.city_structure.global_position, errand.use, [job_posting.city_structure.type], assigned_errands)



func _find_nearest_worker(start_position: Vector2, workers_to_check: Array) -> WorkerQueue.WorkerProfile:
	var actor_dictionary: Dictionary = { }
	
	for profile in workers_to_check:
		actor_dictionary[profile.puppet_master.owner] = profile
	
	var nearest_actor: Node2D = _navigator.nearest_from_array(start_position, actor_dictionary.keys())
	
	return actor_dictionary[nearest_actor]



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
			break
	
	return Quest.new(target, target_profile)





class Quest:
	
	var target: Node2D
	var target_profile: ResourceSightings.ResourceProfile
	
	
	func _init(new_target: Node2D, new_target_profile: ResourceSightings.ResourceProfile):
		target = new_target
		target_profile = new_target_profile
