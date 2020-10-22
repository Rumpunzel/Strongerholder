class_name JobQueue, "res://assets/icons/icon_job_queue.svg"
extends Queue



func add_job(city_pilot_master: Node2D) -> JobPosting:
	var new_posting: JobPosting = JobPosting.new(city_pilot_master)
	
	queue.append(new_posting)
	queue.sort_custom(JobPosting, "sort_ascending")
	
	#print("\nJOB POSTINGS\n%s\n" % [queue])
	
	return new_posting



func remove_job(posting: JobPosting):
	queue.erase(posting)





class JobPosting:
	var city_pilot_master: Node2D
	
	
	func _init(new_city_pilot_master: Node2D):
		city_pilot_master = new_city_pilot_master
	
	
	func assign_worker(puppet_master: Node2D):
		city_pilot_master.employ_worker(puppet_master)
	
	
	func posting_active() -> bool:
		return city_pilot_master.needs_workers()
	
	
	func _to_string() -> String:
		return "\nWorking For: %s\n" % [city_pilot_master.owner.name]
