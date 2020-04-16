class_name StructureHitBox, "res://assets/icons/structures/icon_structure_hit_box.svg"
extends ObjectHitBox


export(Constants.Structures) var type: int setget set_type, get_type
export(Array, Constants.Structures) var blocked_by = [Constants.Structures.EVERYTHING]



func initialize():
	.initialize()
	
	RingMap.connect("city_changed", self, "is_active")
	RingMap.register_structure(type, owner)



func die(sender: ObjectHitBox):
	RingMap.unregister_structure(type, owner)
	.die(sender)




func set_type(new_type: int):
	type = new_type



func is_active() -> bool:
	set_active(not is_blocked() and alive)
	
	return .is_active()


func is_blocked() -> bool:
	for hit_box in overlapping_hit_boxes:
		if blocked_by.has(hit_box.type) or (Constants.is_structure(hit_box.type) and blocked_by.has(Constants.Structures.EVERYTHING)):
			return true
	
	return false


func get_type() -> int:
	return type
