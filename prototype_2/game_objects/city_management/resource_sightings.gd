class_name ResourceSightings, "res://assets/icons/icon_resource_sightings.svg"
extends Queue



func add_resource(structure: GameObject, pilot_master: Node2D) -> ResourceProfile:
	var new_profile: ResourceProfile = resource_registered(structure)
	
	if new_profile:
		return new_profile
	
	if pilot_master:
		new_profile = ResourceProfile.new(structure, pilot_master)
	else:
		new_profile = StandaloneResource.new(structure)
	
	queue.append(new_profile)
	queue.sort_custom(ResourceProfile, "sort_ascending")
	
	#print("\nRESOURCE SIGHTINGS\n%s\n" % [queue])
	
	return new_profile



func remove_resource(profile: ResourceProfile):
	queue.erase(profile)



func get_offering(target_resource, only_stand_alone: bool) -> Array:
	var return_array: Array = [ ]
	
	for profile in queue:
		if (only_stand_alone and not profile is StandaloneResource) or not profile.posting_active():
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



func resource_sighted(resource_type, get_exact_amount: bool = false) -> int:
	var sightings: int = 0
	
	for resource in queue:
		if resource.inventory and resource.inventory.resources_on_offer().has(resource_type):
			sightings += 1
			
			if not get_exact_amount:
				break
	
	return sightings





class ResourceProfile:
	var structure: GameObject
	var pilot_master: Node2D
	
	
	func _init(new_structure, new_pilot_master: Node2D):
		structure = new_structure
		pilot_master = new_pilot_master
	
	
	func resources_on_offer() -> Array:
		return pilot_master.get_inventory_contents()
	
	
	func posting_active() -> bool:
		return structure.is_active() and position_open()
	
	func position_open() -> bool:
		return structure.position_open()



class StandaloneResource extends ResourceProfile:
	func _init(new_structure).(new_structure, null):
		pass
	
	func resources_on_offer() -> Array:
		return [structure]
	
	func position_open() -> bool:
		return structure.position_open()
