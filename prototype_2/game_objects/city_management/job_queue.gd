class_name JobQueue, "res://assets/icons/icon_job_queue.svg"
extends Queue



func add_job(city_structure, requested_resources: Array, requested_workers, request_until_capacity: bool) -> JobPosting:
	var new_posting: JobPosting = JobPosting.new(city_structure, requested_resources, requested_workers, request_until_capacity)
	
	queue.append(new_posting)
	
	print("\nJOB POSTINGS\n%s\n" % [queue])
	
	return new_posting





class JobPosting:
	
	var city_structure
	
	var requested_resources: Array
	var requested_workers
	var request_until_capacity: bool
	
	var assigned_workers: int = 0
	
	
	func _init(new_city_structure, new_requested_resources: Array, new_requested_workers, new_request_until_capacity: bool):
		city_structure = new_city_structure
		
		requested_resources = new_requested_resources
		requested_workers = new_requested_workers
		request_until_capacity = new_request_until_capacity
	
	
	func posting_active() -> bool:
		return not requested_workers or assigned_workers < requested_workers
	
	
	func _to_string() -> String:
		return "\nWorking For: %s\nRequested Delivery: %s\nDeliver Until Capacity: %s\nWorkers Assigned: %s\n" % [city_structure.name, requested_resources, request_until_capacity, ("%d/%d" % [assigned_workers, requested_workers]) if requested_workers else "%d" % [assigned_workers]]

