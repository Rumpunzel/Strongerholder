class_name WorkerQueue, "res://assets/icons/icon_worker_queue.svg"
extends Queue



func add_worker(puppet_master: Node2D, inventories: Array) -> WorkerProfile:
	var new_profile: WorkerProfile = worker_registered(puppet_master)
	
	if new_profile:
		return new_profile
	
	new_profile = WorkerProfile.new(puppet_master, inventories)
	
	queue.append(new_profile)
	queue.sort_custom(WorkerProfile, "sort_ascending")
	
	#print("\nWORKER APPLICATIONS\n%s\n" % [queue])
	
	return new_profile



func remove_worker(profile: WorkerProfile):
	queue.erase(profile)



func worker_registered(puppet_master: Node2D) -> WorkerProfile:
	for profile in queue:
		if profile.puppet_master == puppet_master:
			return profile
	
	return null





class WorkerProfile:
	var puppet_master: Node2D
	var inventories: Array
	
	
	func _init(new_puppet_master: Node2D, new_inventories: Array):
		puppet_master = new_puppet_master
		inventories = new_inventories
	
	
	func can_do_job(potential_jobs: Array) -> Array:
		var items: Array = _get_inventory_contents()
		var usable_items: Array = [ ]
		
		for item in items:
			if potential_jobs.has(item.type):
				usable_items.append(item)
			elif item is CraftTool:
				for use in item.used_for:
					if potential_jobs.has(use):
						usable_items.append(Errand.new(item, use))
		
		return usable_items
	
	
	func get_flexibility() -> int:
		return _get_inventory_contents().size()
	
	static func sort_ascending(a: WorkerProfile, b: WorkerProfile) -> bool:
		return a.get_flexibility() < b.get_flexibility()
	
	
	func _get_inventory_contents() -> Array:
		var contents: Array = [ ]
		
		for inventory in inventories:
			contents += inventory.get_contents()
		
		return contents
	
	
	func _to_string() -> String:
		return "\nWorker: %s\nCurrently Holding: %s\nFlexibility: %d\n" % [puppet_master.owner.name, _get_inventory_contents(), get_flexibility()]




class Errand:
	var craft_tool: Spyglass
	var use
	
	func _init(new_craft_tool: Spyglass, new_use):
		assert(new_craft_tool)
		craft_tool = new_craft_tool
		use = new_use
	
	func _to_string() -> String:
		return "%s: %s" % [craft_tool.name, use]
