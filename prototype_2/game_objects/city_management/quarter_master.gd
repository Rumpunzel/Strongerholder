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




func apply_for_job(puppet_master: Node2D):
	return _worker_queue.add_worker(puppet_master)

func unapply_for_job(puppet_master: Node2D):
	return _worker_queue.remove_worker(puppet_master)


func post_job(city_pilot_master: Node2D, workers_required: int) -> JobQueue.JobPosting:
	return _job_queue.add_job(city_pilot_master, workers_required)

func unpost_job(posting: JobQueue.JobPosting):
	return _job_queue.remove_job(posting)


func register_resource(structure: Node2D, inventory: Inventory, maximum_workers) -> ResourceSightings.ResourceProfile:
	return _resource_sightings.add_resource(structure, inventory, maximum_workers)
	
func unregister_resource(profile: ResourceSightings.ResourceProfile):
	return _resource_sightings.remove_resource(profile)


func inquire_for_resource(puppet_master: Node2D, resource_type, only_active_resources: bool, groups_to_exclude: Array = [ ]) -> Node2D:
	var valid_resource: ResourceHolder = _find_job_target(puppet_master, resource_type, only_active_resources, groups_to_exclude)
	
	return valid_resource.target




func _assign_job():
	if _worker_queue.empty() or _job_queue.empty() or _resource_sightings.empty():
		return
	
	var posting_queue: Array = _job_queue.queue
	var application_queue: Array = _worker_queue.queue
	
	for job_posting in posting_queue:
		while job_posting.posting_active() and not application_queue.empty():
			job_posting.assign_worker(application_queue.pop_front())
	
#	for job_posting in _job_queue.queue:
#		if not _worker_queue.empty():
#			print(_worker_queue)
#			print(job_posting)
#		continue
#
#		var job_requests: Array = job_posting.get_requests()
		
#		_assign_job_to_workers_carrying_the_resource(application_queue, job_posting, job_requests)
#
#		if not job_posting.posting_active():
#			continue
#
#		_assign_job_to_workers_able_to_acquire_the_resource2(application_queue, job_posting, job_requests)



#func _assign_job_to_workers_carrying_the_resource(application_queue: Array, job_posting: JobQueue.JobPosting, job_requests: Array):
#	var relevant_workers: Dictionary = { }
#
#	# First check for any workers currently carrying the desired resources
#	for worker_profile in application_queue:
#		var item_in_pocket: GameResource = worker_profile.can_do_job_now(job_requests)
#
#		if item_in_pocket:
#			relevant_workers[worker_profile] = item_in_pocket
#
#
#	# Then assign workers until the posting is full or all of the workers have been checked
#	while job_posting.posting_active() and not relevant_workers.empty():
#		var nearest_worker: WorkerQueue.WorkerProfile = _find_nearest_worker(job_posting.city_structure.global_position, relevant_workers.keys())
#		var item_in_pocket: GameResource = relevant_workers[nearest_worker]
#
#		relevant_workers.erase(nearest_worker)
#
#		var puppet_master: Node2D = nearest_worker.puppet_master
#		var resource_profile: ResourceSightings.ResourceProfile = _resource_sightings.resource_registered(item_in_pocket)
#
#		if not resource_profile.position_open():
#			continue
#
#		job_posting.assign_worker(puppet_master, resource_profile)
#		puppet_master.new_plan(job_posting.city_structure, job_posting.city_structure, item_in_pocket.type, item_in_pocket, job_posting)
#
#
#
#func _assign_job_to_workers_able_to_acquire_the_resource2(application_queue: Array, job_posting: JobQueue.JobPosting, job_requests: Array):
#	# To cache nearby resources
#	var nearest_resources: Dictionary = { }
#
#	for resource in job_requests:
#		if nearest_resources.get(resource):
#			continue
#
#		nearest_resources[resource] = _navigator.nearest_in_group(job_posting.city_structure.global_position, resource, [job_posting.city_structure.type])
#
#
#	var inactive_resources: Array = [ ]
#
#	# Work until the job posting is filled or all options have been tried
#	#while job_posting.posting_active() and not relevant_workers.empty():
#	for worker_profile in application_queue:
#		if not job_posting.posting_active():
#			break
#
#		var worker_errands: Array = worker_profile.can_do_job_eventually(job_requests)
#
#		if worker_errands.empty():
#			continue
#
#		for errand in worker_errands:
#			print(Constants.enum_name(Constants.Resources, errand.use))
#			var nearest_resource: Node2D = nearest_resources[errand.use]
#			var job_assigned: bool = false
#
#			# If the resource is found on the map
#			while nearest_resource:
#				var resource_profile: ResourceSightings.ResourceProfile = _resource_sightings.resource_registered(nearest_resource)
#
#				if not resource_profile.posting_active():
#					inactive_resources.append(nearest_resource)
#					nearest_resources[errand.use] = _navigator.nearest_in_group(job_posting.city_structure.global_position, errand.use, [job_posting.city_structure.type], inactive_resources)
#
#					continue
#
#				var puppet_master: Node2D = worker_profile.puppet_master
#
#				job_posting.assign_worker(puppet_master, resource_profile)
#				puppet_master.new_plan(job_posting.city_structure, nearest_resource, errand.use, errand.craft_tool, job_posting)
#				job_assigned = true
#
#				break
#
#			if job_assigned:
#				nearest_resources[errand.use] = _navigator.nearest_in_group(job_posting.city_structure.global_position, errand.use, [job_posting.city_structure.type], inactive_resources)
#				break
#
#			# Else if there is not resource lying on the map
#			#	but I could be gathered from structures
#			var puppet_master: Node2D = worker_profile.puppet_master
#			var target_structure: ResourceHolder = _find_job_target(puppet_master, errand.use, false, [job_posting.city_structure.type])
#
#			if target_structure.target:
#				job_posting.assign_worker(puppet_master, target_structure.target_profile)
#				puppet_master.new_plan(job_posting.city_structure, target_structure.target, errand.use, errand.craft_tool, job_posting)
#
#				nearest_resources[errand.use] = _navigator.nearest_in_group(job_posting.city_structure.global_position, errand.use, [job_posting.city_structure.type], inactive_resources)
#
#				break


#func _assign_job_to_workers_able_to_acquire_the_resource(application_queue: Array, job_posting: JobQueue.JobPosting, job_requests: Array):
#	# To gather all the workers able to gather the resource
#	var errand_keys_priorities: Array = [ ]
#	var relevant_workers: Dictionary = { }
#
#	# Gather all the workers able to gather the resource and what they would use to gather it
#	for worker_profile in application_queue:
#		var errands: Array = worker_profile.can_do_job_eventually(job_requests)
#
#		for errand in errands:
#			if not errand_keys_priorities.has(errand.use):
#				errand_keys_priorities.append(errand.use)
#
#			relevant_workers[errand.use] = relevant_workers.get(errand.use, [ ])
#			relevant_workers[errand.use].append({ worker_profile: errand })
#
#
#	# To cache nearby resources
#	var nearest_errands: Dictionary = { }
#
#	for errand in errand_keys_priorities:
#		if nearest_errands.get(errand):
#			continue
#
#		nearest_errands[errand] = _navigator.nearest_in_group(job_posting.city_structure.global_position, errand, [job_posting.city_structure.type])
#
#
#	# To keep track of all the resources assigned this frame
#	#	without this, workers looking for a type of a resource
#	#	which had already been assigned this frame, would not be assigned one
#	#	but the next one
#	var assigned_errands: Array = [ ]
#
#	# Work until the job posting is filled or all options have been tried
#	#while job_posting.posting_active() and not relevant_workers.empty():
#	while not errand_keys_priorities.empty():
#		if not job_posting.posting_active():
#			break
#
#		var errand = errand_keys_priorities.pop_front()
#		var nearest_resource: Node2D = nearest_errands[errand]
#
#		if nearest_resource:
#			var nearest_worker: WorkerQueue.WorkerProfile = _find_nearest_worker(nearest_resource.global_position, relevant_workers[errand].keys())
#			var closest_errand: WorkerQueue.Errand = relevant_workers[errand][nearest_worker]
#
#			relevant_workers[errand].erase(nearest_worker)
#
#			var puppet_master: Node2D = nearest_worker.puppet_master
#			var resource_profile: ResourceSightings.ResourceProfile = _resource_sightings.resource_registered(nearest_resource)
#
#			if not resource_profile.posting_active():
#				continue
#
#			assigned_errands.append(nearest_resource)
#			job_posting.assign_worker(puppet_master, resource_profile)
#			puppet_master.new_plan(job_posting.city_structure, nearest_resource, closest_errand.use, closest_errand.craft_tool, job_posting)
#		else:
#			var nearest_worker: WorkerQueue.WorkerProfile = _find_nearest_worker(job_posting.city_structure.global_position, relevant_workers[errand].keys())
#			var puppet_master: Node2D = nearest_worker.puppet_master
#			var closest_errand: WorkerQueue.Errand = relevant_workers[errand][nearest_worker]
#
#			var new_quest: Quest = _find_job_target(puppet_master, closest_errand.use, [job_posting.city_structure.type])
#
#			relevant_workers[errand].erase(nearest_worker)
#
#			if not new_quest.target:
#				continue
#
#			assigned_errands.append(nearest_resource)
#			job_posting.assign_worker(puppet_master, new_quest.target_profile)
#			puppet_master.new_plan(job_posting.city_structure, new_quest.target, closest_errand.use, closest_errand.craft_tool, job_posting)
#
#		nearest_errands[errand] = _navigator.nearest_in_group(job_posting.city_structure.global_position, errand, [job_posting.city_structure.type], assigned_errands)



func _find_nearest_worker(start_position: Vector2, workers_to_check: Array) -> WorkerQueue.WorkerProfile:
	var actor_dictionary: Dictionary = { }
	
	for profile in workers_to_check:
		actor_dictionary[profile.puppet_master.owner] = profile
	
	var nearest_actor: Node2D = _navigator.nearest_from_array(start_position, actor_dictionary.keys())
	assert(nearest_actor)
	return actor_dictionary[nearest_actor]



func _find_job_target(puppet_master: Node2D, job_target_group, only_active_resources: bool, groups_to_exclude: Array = [ ]) -> ResourceHolder:
	var target: Node2D = null
	var target_profile: ResourceSightings.ResourceProfile = null
	
	var array_of_profiles: Array = _resource_sightings.get_offering(job_target_group, only_active_resources)
	var array_to_search: Array = [ ]
	
	
	for profile in array_of_profiles:
		if profile.position_open():
			array_to_search.append(profile.structure)
	
	target = _navigator.nearest_from_array(puppet_master.global_position, array_to_search, groups_to_exclude)
	
	for profile in array_of_profiles:
		if profile.structure == target:
			target_profile = profile
			break
	
	return ResourceHolder.new(target, target_profile)





class ResourceHolder:
	var target: Node2D
	var target_profile: ResourceSightings.ResourceProfile
	
	
	func _init(new_target: Node2D, new_target_profile: ResourceSightings.ResourceProfile):
		target = new_target
		target_profile = new_target_profile
