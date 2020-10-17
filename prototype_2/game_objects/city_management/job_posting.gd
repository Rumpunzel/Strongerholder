class_name JobPosting, "res://assets/icons/icon_job_posting.svg"
extends Node


var city_structure

var requested_resources: Array
var requested_workers
var request_until_capacity: bool

var assigned_workers: int = 0 setget set_assigned_workers




func _init(new_city_structure, new_requested_resources: Array, new_requested_workers, new_request_until_capacity: bool):
	city_structure = new_city_structure
	
	requested_resources = new_requested_resources
	requested_workers = new_requested_workers
	request_until_capacity = new_request_until_capacity




func set_assigned_workers(new_amount: int):
	assigned_workers = new_amount
	
	if requested_workers and assigned_workers >= requested_workers:
		queue_free()



func _to_string() -> String:
	return "\nWorking For: %s\nRequested Delivery: %s\nDeliver Until Capacity: %s\nWorkers Assigned: %s\n" % [city_structure.name, requested_resources, request_until_capacity, ("%d/%d" % [assigned_workers, requested_workers]) if requested_workers else "%d" % [assigned_workers]]
