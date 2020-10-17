class_name JobQueue, "res://assets/icons/icon_job_queue.svg"
extends Node



func add_job(city_structure, requested_resources: Array, requested_workers, request_until_capacity: bool):
	insert_element(JobPosting.new(city_structure, requested_resources, requested_workers, request_until_capacity))
	
	print("JOB POSTINGS\n%s\n" % [get_queue()])



func insert_element(new_element: Object):
	add_child(new_element)


func empty() -> bool:
	return get_child_count() == 0


func get_queue() -> Array:
	return get_children()
