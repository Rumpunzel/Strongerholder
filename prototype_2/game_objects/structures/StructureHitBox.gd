class_name StructureHitBox, "res://assets/icons/structures/icon_structure_hit_box.svg"
extends ObjectHitBox


export(Constants.Structures) var type: int
export(Array, Constants.Structures) var _blocked_by = [ ]




#func initialize():
#	.initialize()
#
#	owner.add_to_group(Constants.enum_name(Constants.Structures, type))
	
	#RingMap.connect("city_changed", self, "is_active")



#func die(sender: ObjectHitBox):
#	#RingMap.unregister_structure(type, owner)
#	.die(sender)



#func is_active() -> bool:
#	set_active(not is_blocked() and alive)
#
#	return .is_active()


#func is_blocked() -> bool:
#	for hit_box in _overlapping_hit_boxes:
#		if _blocked_by.has(hit_box.type) or ((Constants.is_structure(hit_box.type) or Constants.is_thing(hit_box.type)) and _blocked_by.has(Constants.Structures.EVERYTHING)):
#			return true
#
#	return false
