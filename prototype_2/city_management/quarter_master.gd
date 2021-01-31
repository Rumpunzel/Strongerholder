class_name QuarterMaster, "res://assets/icons/icon_quarter_master.svg"
extends Node


const PERSIST_AS_PROCEDURAL_OBJECT: bool = false

const PERSIST_PROPERTIES := ["name"]
const PERSIST_OBJ_PROPERTIES := ["_worker_queue", "_job_queue", "_resource_sightings", "storage_buildings"]


var _worker_queue: Array = [ ]
var _job_queue: Array = [ ]

var _resource_sightings: Array = [ ]


var storage_buildings: Dictionary = { }


onready var _navigator: Navigator = ServiceLocator.navigator




func _enter_tree() -> void:
	ServiceLocator.register_as_quarter_master(self)

func _process(_delta: float) -> void:
	_assign_job()

func _exit_tree() -> void:
	ServiceLocator.unregister_as_quarter_master(self)




func apply_for_job(puppet_master: Node2D) -> void:
	_worker_queue.append(puppet_master)

func unapply_for_job(puppet_master: Node2D) -> void:
	_worker_queue.erase(puppet_master)


func post_job(city_pilot_master: Node2D) -> void:
	_job_queue.append(city_pilot_master)

func unpost_job(posting: Node2D) -> void:
	_job_queue.erase(posting)



func register_storage(storage: StaticBody2D, resource) -> void:
	storage_buildings[resource] = storage_buildings.get(resource, [ ]) + [ storage ]

func unregister_storage(storage: StaticBody2D,resource) -> void:
	storage_buildings.get(resource, [ ]).erase(storage)


func nearest_storage(grid_position: Vector2, resource) -> Node2D:
	var storages: Array = storage_buildings.get(resource, [ ])
	
	return _navigator.nearest_from_array(grid_position, storages)



func register_resource(structure: Node2D) -> void:
	_resource_sightings.append(structure)

func unregister_resource(structure: Node2D) -> void:
	_resource_sightings.erase(structure)


func inquire_for_resource(puppet_master: Node2D, resource_type, only_active_resources: bool, groups_to_exclude: Array = [ ]) -> Node2D:
	return _find_job_target(puppet_master, resource_type, only_active_resources, groups_to_exclude)




func _assign_job() -> void:
	if _worker_queue.empty() or _job_queue.empty() or _resource_sightings.empty():
		return
	
	for job_posting in _job_queue:
		while job_posting.needs_workers() and not _worker_queue.empty():
			job_posting.employ_worker(_worker_queue.pop_front())



func _find_job_target(puppet_master: Node2D, job_target_group, only_active_resources: bool, groups_to_exclude: Array = [ ]) -> Node2D:
	var target: Node2D = null
	var array_to_search: Array = [ ]
	
	for resource in _resource_sightings:
		if not resource or (only_active_resources and not resource is GameResource) or not (resource.is_active() and resource.position_open(puppet_master)):
			continue
		
		var items: Array
		
		if resource is GameResource:
			items = [resource]
		elif not only_active_resources:
			items = resource._pilot_master.get_inventory_contents()
		
		
		for item in items:
			if item.type == job_target_group and item.position_open(puppet_master):
				array_to_search.append(resource)
	
	
	target = _navigator.nearest_from_array(puppet_master.global_position, array_to_search, groups_to_exclude)
	
	return target
