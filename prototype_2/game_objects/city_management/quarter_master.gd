class_name QuarterMaster, "res://assets/icons/icon_quarter_master.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false

const PERSIST_PROPERTIES := ["name"]
const PERSIST_OBJ_PROPERTIES := ["_worker_queue", "_job_queue", "_resource_sightings"]


onready var _worker_queue: Array = [ ]
onready var _job_queue: Array = [ ]
onready var _resource_sightings: Array = [ ]

onready var _navigator: Navigator = ServiceLocator.navigator




func _enter_tree():
	ServiceLocator.register_as_quarter_master(self)

func _process(_delta: float):
	_assign_job()

func _exit_tree():
	ServiceLocator.unregister_as_quarter_master(self)




func apply_for_job(puppet_master: Node2D):
	return _worker_queue.append(puppet_master)

func unapply_for_job(puppet_master: Node2D):
	return _worker_queue.erase(puppet_master)


func post_job(city_pilot_master: Node2D):
	return _job_queue.append(city_pilot_master)

func unpost_job(posting: Node2D):
	return _job_queue.erase(posting)


func register_resource(structure: Node2D):
	return _resource_sightings.append(structure)
	
func unregister_resource(structure: Node2D):
	return _resource_sightings.erase(structure)


func inquire_for_resource(puppet_master: Node2D, resource_type, only_active_resources: bool, groups_to_exclude: Array = [ ]) -> Node2D:
	return _find_job_target(puppet_master, resource_type, only_active_resources, groups_to_exclude)




func _assign_job():
	if _worker_queue.empty() or _job_queue.empty() or _resource_sightings.empty():
		return
	
	for job_posting in _job_queue:
		while job_posting.needs_workers() and not _worker_queue.empty():
			job_posting.employ_worker(_worker_queue.pop_front())



func _find_job_target(puppet_master: Node2D, job_target_group, only_active_resources: bool, groups_to_exclude: Array = [ ]) -> Node2D:
	var target: Node2D = null
	var array_to_search: Array = [ ]
	
	for resource in _resource_sightings:
		if not resource or (only_active_resources and not resource is GameResource) or not (resource.is_active() and resource.position_open()):
			continue
		
		var items: Array
		
		if resource is GameResource:
			items = [resource]
		elif not only_active_resources:
			items = resource._pilot_master.get_inventory_contents()
		
		
		for item in items:
			if item.type == job_target_group and item.position_open():
				array_to_search.append(resource)
	
	
	target = _navigator.nearest_from_array(puppet_master.global_position, array_to_search, groups_to_exclude)
	
	return target
