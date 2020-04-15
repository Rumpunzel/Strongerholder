class_name StructureHitBox
extends ObjectHitBox


export(Constants.Structures) var type: int setget set_type, get_type
export(Array, Constants.Structures) var blocked_by



# Called when the node enters the scene tree for the first time.
func _ready():
	RingMap.register_structure(type, owner)
	
	yield(get_tree(), "idle_frame")
	
	RingMap.connect("city_changed", self, "is_active")



func build_into(new_type):
	if new_type is String:
		new_type = new_type.replace(" ", "_").to_upper()
		new_type = Constants.Structures.values()[Constants.Structures.keys().find(new_type)]
	
	set_type(new_type)
	#set_object(object_scenes[type].instance())
	
	RingMap.update_structure(type, new_type, owner)



func die(sender):
	RingMap.unregister_structure(type, owner)
	
	.die(sender)




func set_type(new_type):
	type = new_type



func is_active() -> bool:
	var new_active = true
	
	for hit_box in overlapping_hit_boxes:
		new_active = not blocked_by.has(hit_box.type)
		
		if not new_active:
			break
	
	set_active(new_active)
	
	return .is_active()


func get_type() -> int:
	return type
