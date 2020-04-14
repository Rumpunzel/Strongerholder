class_name StructureHitBox
extends ObjectHitBox


export(Constants.Structures) var type: int setget , get_type
export(Constants.Structures) var blocked_by



# Called when the node enters the scene tree for the first time.
func _ready():
	RingMap.register_structure(type, owner)
	
	yield(get_tree(), "idle_frame")
	
	RingMap.connect("city_changed", self, "is_active")



func build_into(new_type):
	if new_type is String:
		new_type = new_type.replace(" ", "_").to_upper()
		new_type = Constants.Structures.values()[Constants.Structures.keys().find(new_type)]
	
	#set_type(new_type)
	#set_object(object_scenes[type].instance())
	
	RingMap.update_structure(type, new_type, self)



func die(sender):
	RingMap.unregister_structure(type, owner)
	
	.die(sender)




func is_active() -> bool:
	if not blocked_by == Constants.Structures.NOTHING:
		var new_active = true
		
		for hit_box in overlapping_hit_boxes:
			new_active = not hit_box.type == blocked_by
			
			if not new_active:
				break
		
		set_active(new_active)
	
	return .is_active()


func get_type() -> int:
	return type