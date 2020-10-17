class_name ResourceSightings, "res://assets/icons/icon_resource_sightings.svg"
extends Queue



func add_resource(structure, inventory: Inventory, maximum_workers) -> ResourceProfile:
	var new_profile: ResourceProfile = resource_registered(structure)
	
	if new_profile:
		return new_profile
	
	new_profile = ResourceProfile.new(structure, inventory, maximum_workers)
	
	queue.append(new_profile)
	queue.sort_custom(ResourceProfile, "sort_ascending")
	
	print("\nRESOURCE SIGHTINGS\n%s\n" % [queue])
	
	return new_profile



func resource_registered(structure) -> ResourceProfile:
	for profile in queue:
		if profile.structure == structure:
			return profile
	
	return null





class ResourceProfile:
	
	var structure
	
	var inventory: Inventory
	var maximum_workers
	
	var assigned_workers: int = 0
	
	
	func _init(new_structure, new_inventory: Inventory, new_maximum_workers):
		structure = new_structure
		
		inventory = new_inventory
		maximum_workers = new_maximum_workers
	
	
	func resources_on_offer() -> Array:
		return inventory.get_contents()
	
	
	func posting_active() -> bool:
		return not maximum_workers or assigned_workers < maximum_workers
	
	
	func _to_string() -> String:
		return "\nStructure: %s\nCurrently Offering: %s\nWorkers Assigned: %s\n" % [structure.name, resources_on_offer(), ("%d/%d" % [assigned_workers, maximum_workers]) if maximum_workers else "%d" % [assigned_workers]]




class Errand:
	
	var craft_tool: CraftTool
	var use
	
	
	func _init(new_craft_tool: CraftTool, new_use):
		craft_tool = new_craft_tool
		use = new_use
