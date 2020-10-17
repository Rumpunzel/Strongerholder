class_name JobQueue, "res://assets/icons/icon_job_queue.svg"
extends Queue



func add_job(city_structure: Node2D, city_pilot_master: Node2D, requested_workers, request_until_capacity: bool) -> JobPosting:
	var new_posting: JobPosting = JobPosting.new(city_structure, city_pilot_master, requested_workers, request_until_capacity)
	
	queue.append(new_posting)
	
	#print("\nJOB POSTINGS\n%s\n" % [queue])
	
	return new_posting



func remove_job(posting: JobPosting):
	queue.erase(posting)



func empty() -> bool:
	if .empty():
		return true
	
	for posting in queue:
		if posting.posting_active():
			return false
	
	return true





class JobPosting:
	
	var city_structure: Node2D
	
	var city_pilot_master: Node2D
	var requested_workers
	var request_until_capacity: bool
	
	var _assigned_workers: Dictionary = { }
	
	
	func _init(new_city_structure: Node2D, new_city_pilot_master: Node2D, new_requested_workers, new_request_until_capacity: bool):
		city_structure = new_city_structure
		
		city_pilot_master = new_city_pilot_master
		requested_workers = new_requested_workers
		request_until_capacity = new_request_until_capacity
	
	
	func get_requests() -> Array:
		return city_pilot_master.requests
	
	
	func posting_active() -> bool:
		return city_structure.is_active() and not requested_workers or _assigned_workers.size() < requested_workers
	
	
	func assign_worker(puppet_master: Node2D, target_profile: ResourceSightings.ResourceProfile):
		target_profile.assign_worker(puppet_master)
		_assigned_workers[puppet_master] = target_profile
	
	
	func unassign_worker(puppet_master: Node2D):
		_assigned_workers[puppet_master].unassign_worker(puppet_master)
		_assigned_workers.erase(puppet_master)
	
	
	func _to_string() -> String:
		return "\nWorking For: %s\nRequested Delivery: %s\nDeliver Until Capacity: %s\nWorkers Assigned: %s\n\nWorkers:\n%s\n" % [city_structure.name, city_pilot_master.requests, request_until_capacity, ("%d/%d" % [_assigned_workers.size(), requested_workers]) if requested_workers else "%d" % [_assigned_workers.size()], _assigned_workers]
