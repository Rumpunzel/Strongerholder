class_name ResourceSightings, "res://assets/icons/icon_resource_sightings.svg"
extends Queue



func add_resource(structure, inventory: Inventory) -> ResourceProfile:
	var new_profile: ResourceProfile = resource_registered(structure)
	
	if new_profile:
		return new_profile
	
	new_profile = ResourceProfile.new(structure, inventory)
	
	queue.append(new_profile)
	queue.sort_custom(ResourceProfile, "sort_ascending")
	
	#print("\nRESOURCE SIGHTINGS\n%s\n" % [queue])
	
	return new_profile



func resource_registered(structure) -> ResourceProfile:
	for profile in queue:
		if profile.structure == structure:
			return profile
	
	return null





class ResourceProfile:
	
	var structure
	
	var inventory: Inventory
	
	
	
	func _init(new_structure, new_inventory: Inventory):
		structure = new_structure
		inventory = new_inventory
	
	
	
	func can_do_job_now(potential_jobs: Array) -> GameResource:
		var items: Array = _get_inventory_contents()
		
		for item in items:
			if potential_jobs.has(item.type):
				return item
		
		return null
	
	
	
	func _get_inventory_contents() -> Array:
		return inventory.get_contents()
	
	
#	func _to_string() -> String:
#		return "\nWorker: %s\nCurrently Holding: %s\nAble To Obtain: %s\nFlexibility: %d\n" % [puppet_master.owner.name, _get_inventory_contents(), _get_tool_uses(), get_flexibility()]




class Errand:
	
	var craft_tool: CraftTool
	var use
	
	
	func _init(new_craft_tool: CraftTool, new_use):
		craft_tool = new_craft_tool
		use = new_use
