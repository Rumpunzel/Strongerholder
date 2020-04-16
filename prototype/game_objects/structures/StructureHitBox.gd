class_name StructureHitBox
extends ObjectHitBox


export(Constants.Structures) var type: int setget set_type, get_type
export(Array, Constants.Structures) var blocked_by = [Constants.Structures.EVERYTHING]



func initialize():
	.initialize()
	
	RingMap.connect("city_changed", self, "is_active")
	RingMap.register_structure(type, owner)


func build_into(new_type):
	if new_type is String:
		new_type = new_type.replace(" ", "_").to_upper()
		new_type = Constants.Structures.values()[Constants.Structures.keys().find(new_type)]
	
	set_type(new_type)
	
	RingMap.update_structure(type, new_type, owner)



func die(sender):
	RingMap.unregister_structure(type, owner)
	.die(sender)




func set_type(new_type):
	type = new_type



func is_active() -> bool:
	set_active(not is_blocked())
	
	return .is_active()


func is_blocked() -> bool:
	for hit_box in overlapping_hit_boxes:
		if blocked_by.has(hit_box.type) or (Constants.is_structure(hit_box.type) and blocked_by.has(Constants.Structures.EVERYTHING)):
			return true
	
	return false


func get_type() -> int:
	return type
