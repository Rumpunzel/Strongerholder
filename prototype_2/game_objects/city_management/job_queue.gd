class_name JobQueue, "res://assets/icons/icon_job_queue.svg"
extends Queue



func add_job(city_pilot_master: Node2D, workers_required: int) -> JobPosting:
	var new_posting: JobPosting = JobPosting.new(city_pilot_master, workers_required)
	
	queue.append(new_posting)
	queue.sort_custom(JobPosting, "sort_ascending")
	
	#print("\nJOB POSTINGS\n%s\n" % [queue])
	
	return new_posting



func remove_job(posting: JobPosting):
	queue.erase(posting)





class JobPosting:
	var city_pilot_master: Node2D
	var workers_required: int
	
	
	func _init(new_city_pilot_master: Node2D, new_workers_required: int):
		city_pilot_master = new_city_pilot_master
		workers_required = new_workers_required
	
	
	func assign_worker(puppet_master: Node2D):
		workers_required += 1
		city_pilot_master.employ_worker(puppet_master)
	
	
	func posting_active() -> bool:
		return workers_required > 0
	
	
	func _to_string() -> String:
		return "\nWorking For: %s\nWorkers Required: %d\n" % [city_pilot_master.owner.name, workers_required]
