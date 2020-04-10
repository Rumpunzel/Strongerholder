class_name ActorBehavior
extends Resource


signal new_object_of_interest(object_of_interest)


const INVENTORY_EMPTY = "inventory_empty"
const RAW_MATERIAL = "raw_material"
const PROCESSED_MATERIAL = "processed_material"


const ACTOR_PRIORITIES = {
	Constants.Objects.PLAYER: { },
	Constants.Objects.WOODSMAN: {
		INVENTORY_EMPTY: [ Constants.Objects.TREE, ],
		RAW_MATERIAL: [ Constants.Objects.WOODCUTTERS_HUT, Constants.Objects.STOCKPILE, ],
		PROCESSED_MATERIAL: [ Constants.Objects.STOCKPILE, ],
	},
}


var object_of_interest: GameObject = null setget set_object_of_interest, get_object_of_interest


var current_actor
var ring_map: RingMap
var priorities: Dictionary = { }
var currently_looking_for: int = Constants.Objects.NOTHING




func _init(new_actor, new_ring_map):
	current_actor = new_actor
	set_priorities(current_actor.type)
	
	ring_map = new_ring_map
	ring_map.connect("city_changed", self, "force_search")




func next_priority() -> GameObject:
	var status: String
	
	if current_actor.inventory.empty():
		status = INVENTORY_EMPTY
	elif current_actor.inventory.has("Wood"):
		status = RAW_MATERIAL
	else:
		status = PROCESSED_MATERIAL
	
	var priority_list: Array = priorities.get(status, [ ])
	var next_target: GameObject = null
	
	for target_type in priority_list:
		if not target_type == currently_looking_for:
			next_target = ring_map.city_navigator.get_nearest(current_actor.ring_vector, target_type)
			currently_looking_for = target_type
		else:
			next_target = object_of_interest
		
		if next_target:
			break
	
	return next_target


func force_search():
	set_object_of_interest(next_priority())



func set_priorities(new_actor: int):
	priorities = ACTOR_PRIORITIES.get(new_actor, { })

func set_object_of_interest(new_object: GameObject):
	if not new_object == object_of_interest:
		object_of_interest = new_object
		
		if object_of_interest:
			emit_signal("new_object_of_interest", object_of_interest)


func get_object_of_interest() -> GameObject:
	return object_of_interest
