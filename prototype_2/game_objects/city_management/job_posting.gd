class_name JobPosting, "res://assets/icons/icon_job_posting.svg"
extends Node


var city_structure

var requested_resources: Array
var requested_workers: int

var assigned_workers: int = 0 setget set_assigned_workers




func _init(new_city_structure, new_requested_resources: Array, new_requested_workers: int):
	city_structure = new_city_structure
	
	requested_resources = new_requested_resources
	requested_workers = new_requested_workers




func set_assigned_workers(new_amount: int):
	assigned_workers = new_amount
	
	if assigned_workers >= requested_workers:
		queue_free()
