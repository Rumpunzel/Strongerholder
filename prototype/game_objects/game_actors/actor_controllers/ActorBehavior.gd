class_name ActorBehavior
extends Resource


signal new_object_of_interest(object_of_interest)


const ACTOR_PRIORITIES: Dictionary = {
	Constants.Actors.PLAYER: { },
	
	Constants.Actors.WOODSMAN: {
		Constants.Resources.NOTHING: [ Constants.Resources.WOOD, ],
		Constants.Resources.WOOD: [ Constants.REQUEST + Constants.Resources.WOOD, ],
	},
	
	Constants.Actors.CARPENTER: {
		Constants.Resources.NOTHING: [ Constants.Resources.WOOD_PLANKS, Constants.Resources.WOOD, ],
		Constants.Resources.WOOD_PLANKS: [ Constants.REQUEST + Constants.Resources.WOOD_PLANKS, ],
		Constants.Resources.WOOD: [ Constants.Structures.WOODCUTTERS_HUT, ],
	},
}

const TARGET_TYPE: String = "target_type"
const TARGET_RESOURCE: String = "target_resource"


var priorities: Dictionary = { }
var object_of_interest = null setget set_object_of_interest
var currently_looking_for: Dictionary = { }


var _inventory: Inventory




func _init(new_behavior: int, new_inventory: Inventory):
	set_priorities_from_actor(new_behavior)
	_inventory = new_inventory




func force_search(actor_position: RingVector, reset_target_type: bool = true):
	if reset_target_type:
		currently_looking_for = { }
	
	set_object_of_interest(_next_priority(actor_position))



func _next_priority(actor_position: RingVector):
	var next_target = null
	var next_status: int = Constants.Resources.NOTHING
	
	if not _inventory.empty():
		for status in priorities.keys():
			if _inventory.has(status):
				next_status = status
	
	
	var priority_list: Array = priorities.get(next_status, [ ])
	
	for target_type in priority_list:
		if not target_type == currently_looking_for.get(TARGET_TYPE):
			var target_priorities: Array = priorities.get(target_type, [ ])
			var dictionary: Dictionary = { }
			var targets_exists: bool = true
			
			if Constants.is_request(target_type):
				dictionary = RingMap.resources.dictionary
				
			elif Constants.is_resource(target_type):
				dictionary = RingMap.resources.dictionary
				targets_exists = false
				
				for prio in target_priorities:
					if RingMap.structures.dictionary.has(prio) or RingMap.resources.dictionary.has(prio):
						targets_exists = true
						break
				
			else:
				dictionary = RingMap.structures.dictionary
			
			if targets_exists:
				next_target = RingMap.city_navigator.get_nearest(dictionary, target_type, actor_position, target_priorities)
		else:
			next_target = object_of_interest
		
		if next_target:
			currently_looking_for = { TARGET_TYPE: target_type, TARGET_RESOURCE: next_status }
			break
	
	if not next_target:
		currently_looking_for = { }
	
	return next_target




func set_priorities_from_actor(new_actor: int):
	priorities = ACTOR_PRIORITIES.get(new_actor, { })

func set_object_of_interest(new_object):
	if not new_object == object_of_interest:
		object_of_interest = new_object
		
		emit_signal("new_object_of_interest", object_of_interest)
