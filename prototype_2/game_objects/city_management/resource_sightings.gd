class_name ResourceSightings, "res://assets/icons/icon_resource_sightings.svg"
extends Queue



func add_resource(structure, inventory: Inventory, maximum_workers) -> ResourceProfile:
	var new_profile: ResourceProfile = resource_registered(structure)
	
	if new_profile:
		return new_profile
	
	if inventory:
		new_profile = ResourceProfile.new(structure, inventory, maximum_workers)
	else:
		new_profile = StandaloneResource.new(structure, maximum_workers)
	
	queue.append(new_profile)
	queue.sort_custom(ResourceProfile, "sort_ascending")
	
	#print("\nRESOURCE SIGHTINGS\n%s\n" % [queue])
	
	return new_profile



func remove_resource(profile: ResourceProfile):
	queue.erase(profile)



func get_offering(target_resource) -> Array:
	var return_array: Array = [ ]
	
	for profile in queue:
		if not profile.posting_active():
			continue
		
		var stock: Array = profile.resources_on_offer()
		
		for item in stock:
			if item.type == target_resource:
				return_array.append(profile)
	
	return return_array



func resource_registered(structure) -> ResourceProfile:
	for profile in queue:
		if profile.structure == structure:
			return profile
	
	return null





class ResourceProfile:
	
	var structure
	
	var inventory: Inventory
	var maximum_workers
	
	var _assigned_workers: Array = [ ]
	
	
	func _init(new_structure, new_inventory: Inventory, new_maximum_workers):
		structure = new_structure
		
		inventory = new_inventory
		maximum_workers = new_maximum_workers
	
	
	func resources_on_offer() -> Array:
		return inventory.get_contents()
	
	
	func posting_active() -> bool:
		return structure.is_active() and position_open()
	
	
	func position_open() -> bool:
		return not maximum_workers or _assigned_workers.size() < maximum_workers
	
	
	func assign_worker(puppet_master: Node2D):
		assert(not maximum_workers or _assigned_workers.size() < maximum_workers)
		_assigned_workers.append(puppet_master)
	
	
	func unassign_worker(puppet_master: Node2D):
		_assigned_workers.erase(puppet_master)
	
	
	func _to_string() -> String:
		return "\nStructure: %s\nCurrently Offering: %s\nWorkers Assigned: %s\n" % [structure.name, resources_on_offer(), ("%d/%d" % [_assigned_workers.size(), maximum_workers]) if maximum_workers else "%d" % [_assigned_workers.size()]]




class StandaloneResource extends ResourceProfile:
	
	
	func _init(new_structure, new_maximum_workers).(new_structure, null, new_maximum_workers):
		pass
	
	
	func resources_on_offer() -> Array:
		return [structure]
