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


func register_resource(structure: Node2D, pilot_master: Node2D) -> ResourceSightings.ResourceProfile:
	return _resource_sightings.add_resource(structure, pilot_master)
	
func unregister_resource(profile: ResourceSightings.ResourceProfile):
	return _resource_sightings.remove_resource(profile)


func inquire_for_resource(puppet_master: Node2D, resource_type, only_active_resources: bool, groups_to_exclude: Array = [ ]) -> Node2D:
	return _find_job_target(puppet_master, resource_type, only_active_resources, groups_to_exclude)




func _assign_job():
	if _worker_queue.empty() or _job_queue.empty() or _resource_sightings.empty():
		return
	
	var posting_queue: Array = _job_queue.queue
	var application_queue: Array = _worker_queue.queue
	
	for job_posting in posting_queue:
		while job_posting.posting_active() and not application_queue.empty():
			job_posting.assign_worker(application_queue.pop_front())



func _find_job_target(puppet_master: Node2D, job_target_group, only_active_resources: bool, groups_to_exclude: Array = [ ]) -> Node2D:
	var target: Node2D = null
	var target_profile: ResourceSightings.ResourceProfile = null
	
	var array_of_profiles: Array = _resource_sightings.get_offering(job_target_group, only_active_resources)
	var array_to_search: Array = [ ]
	
	
	for profile in array_of_profiles:
		if profile.position_open():
			array_to_search.append(profile.structure)
	
	target = _navigator.nearest_from_array(puppet_master.global_position, array_to_search, groups_to_exclude)
	
	return target
