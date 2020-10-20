class_name WorkerQueue, "res://assets/icons/icon_worker_queue.svg"
extends Queue



func add_worker(puppet_master: Node2D, inventory: Inventory, tool_belt: ToolBelt) -> WorkerProfile:
	var new_profile: WorkerProfile = worker_registered(puppet_master)
	
	if new_profile:
		return new_profile
	
	new_profile = WorkerProfile.new(puppet_master, inventory, tool_belt)
	
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
	
	var inventory: Inventory
	var tool_belt: ToolBelt
	
	
	func _init(new_puppet_master: Node2D, new_inventory: Inventory, new_tool_belt: ToolBelt):
		puppet_master = new_puppet_master
		
		inventory = new_inventory
		tool_belt = new_tool_belt
	
	
	func can_do_job_now(potential_jobs: Array) -> GameResource:
		var items: Array = _get_inventory_contents()
		
		for item in items:
			if potential_jobs.has(item.type):
				return item
		
		return null
	
	func can_do_job_eventually(potential_jobs: Array) -> Errand:
		var craft_tools: Array = tool_belt.get_tools()
		
		for craft_tool in craft_tools:
			for use in craft_tool.used_for:
				if potential_jobs.has(use):
					return Errand.new(craft_tool, use)
		
		return null
	
	
	func get_flexibility() -> int:
		return _get_inventory_contents().size() + _get_tool_uses().size()
	
	static func sort_ascending(a: WorkerProfile, b: WorkerProfile) -> bool:
		return a.get_flexibility() < b.get_flexibility()
	
	
	func _get_inventory_contents() -> Array:
		return inventory.get_contents()
	
	func _get_tool_uses() -> Array:
		return tool_belt.get_valid_targets()
	
	
	func _to_string() -> String:
		return "\nWorker: %s\nCurrently Holding: %s\nAble To Obtain: %s\nFlexibility: %d\n" % [puppet_master.owner.name, _get_inventory_contents(), _get_tool_uses(), get_flexibility()]




class Errand:
	var craft_tool: CraftTool
	var use
	
	func _init(new_craft_tool: CraftTool, new_use):
		craft_tool = new_craft_tool
		use = new_use
	
	func _to_string() -> String:
		return "%s: %s" % [craft_tool.name, use]
