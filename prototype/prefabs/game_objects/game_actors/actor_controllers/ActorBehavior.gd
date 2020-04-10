class_name ActorBehavior
extends Resource


signal new_object_of_interest(object_of_interest)


const INVENTORY_EMPTY = "inventory_empty"


const ACTOR_PRIORITIES = {
	Constants.Objects.PLAYER: { },
	
	Constants.Objects.WOODSMAN: {
		INVENTORY_EMPTY: [ Constants.Objects.WOOD, ],
		Constants.Objects.WOOD: [ Constants.Objects.STOCKPILE ]#Constants.Objects.WOOD + Constants.REQUEST, ],
	},
	
	Constants.Objects.CARPENTER: {
		INVENTORY_EMPTY: [ Constants.Objects.WOOD_PLANKS, Constants.Objects.WOOD, ],
		Constants.Objects.WOOD_PLANKS: [ Constants.Objects.WOOD_PLANKS + Constants.REQUEST, ],
		Constants.Objects.WOOD: [ Constants.Objects.WOODCUTTERS_HUT, ],
	},
}


var object_of_interest: GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_looking_for: int = Constants.Objects.NOTHING setget set_currently_looking_for, get_currently_looking_for


var current_actor
var ring_map: RingMap
var priorities: Dictionary = { }




func _init(new_actor, new_ring_map):
	current_actor = new_actor
	set_priorities(current_actor.type)
	
	ring_map = new_ring_map
	ring_map.connect("city_changed", self, "force_search")




func next_priority() -> GameObject:
	var next_target: GameObject = null
	var next_status = INVENTORY_EMPTY
	
	if not current_actor.inventory.empty():
		for status in priorities.keys():
			if current_actor.inventory.has(status):
				next_status = status
	
	
	var priority_list: Array = priorities.get(next_status, [ ])
	
	for target_type in priority_list:
		if not target_type == currently_looking_for:
			var target_priorities = priorities.get(target_type, [ ])
			var dictionary: Dictionary = { }
			var targets_exist = true
			
			match Constants.object_type(target_type):
				Constants.REQUEST:
					dictionary = ring_map.requests.dictionary
					target_type -= Constants.REQUEST
					print(dictionary)
				
				Constants.RESOURCES:
					dictionary = ring_map.resources.dictionary
					targets_exist = false
					
					for prio in target_priorities:
						if ring_map.structures.dictionary.has(prio):
							targets_exist = true
							break
						elif ring_map.requests.dictionary.has(prio - Constants.REQUEST):
							targets_exist = true
							break
				
				_:
					dictionary = ring_map.structures.dictionary
			
			if targets_exist:
				next_target = ring_map.city_navigator.get_nearest(dictionary, target_type, current_actor.ring_vector, target_priorities)
		else:
			next_target = object_of_interest
		
		if next_target:
			currently_looking_for = target_type
			break
	
	if not next_target:
		currently_looking_for = Constants.Objects.NOTHING
	
#	if not next_target == object_of_interest:
#		print("%s is looking for: %s%s" % [current_actor.name, Constants.enum_name(Constants.Objects, currently_looking_for), (" and found it in: %s" % [next_target.name]) if next_target else ""])
	
	return next_target


func force_search(reset_target: bool = false):
	if reset_target:
		currently_looking_for = Constants.Objects.NOTHING
	
	set_object_of_interest(next_priority())



func set_priorities(new_actor: int):
	priorities = ACTOR_PRIORITIES.get(new_actor, { })

func set_object_of_interest(new_object: GameObject):
	if not new_object == object_of_interest:
		object_of_interest = new_object
		
		emit_signal("new_object_of_interest", object_of_interest)

func set_currently_looking_for(new_type: int):
	currently_looking_for = new_type


func get_object_of_interest() -> GameObject:
	return object_of_interest

func get_currently_looking_for() -> int:
	return currently_looking_for
