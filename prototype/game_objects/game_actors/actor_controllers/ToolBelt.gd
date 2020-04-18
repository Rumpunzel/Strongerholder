class_name ToolBelt, "res://assets/icons/game_actors/icon_tool_belt.svg"
extends GameAudioPlayer


signal new_object_of_interest(object_of_interest)


const TARGET_TYPE: String = "target_type"
const TARGET_RESOURCE: String = "target_resource"


export(NodePath) var _inventory_node
export(NodePath) var _animation_player_node
export(NodePath) var _animation_tree_node


var object_of_interest = null setget set_object_of_interest
var currently_looking_for: Dictionary = { }


onready var _inventory: Inventory = get_node(_inventory_node)
onready var _animation_player: AnimationPlayer = get_node(_animation_player_node)
onready var _animation_tree: AnimationStateMachine = get_node(_animation_tree_node)
onready var _priorities: Dictionary = { }




func _ready():
	_construct_priorites()
	force_search()
	
	RingMap.connect("city_changed", self, "force_search")
	RingMap.connect("resources_changed", self, "force_search", [false, true])




func interact_with(other_hit_box: ObjectHitBox, own_hit_box: ActorHitBox):
	if other_hit_box:
		var animation = null
		
		for child in get_children():
			animation = child.check_for_interaction(other_hit_box)
			
			if animation:
				_animation_tree.travel(animation)
				
				yield(_animation_player, "acted")
				
				child.interact_with(other_hit_box, own_hit_box, self)
				return
		
		
		var target_type = currently_looking_for.get(TARGET_TYPE)
		var target_resource = currently_looking_for.get(TARGET_RESOURCE)
		
		if Constants.is_request(target_resource):
			target_resource -= Constants.REQUEST
		
		if Constants.is_resource(target_type):
			_animation_tree.travel("give")
			
			yield(_animation_player, "acted")
			
			own_hit_box.request_item(target_type, other_hit_box)
			return
		
		
		_animation_tree.travel("give")
		
		yield(_animation_player, "acted")
		
		own_hit_box.offer_item(target_resource, other_hit_box)




func force_search(reset_target_type: bool = true, super_soft_reset: bool = false):
	if not super_soft_reset or currently_looking_for.empty():
		if reset_target_type:
			currently_looking_for = { }
		
		set_object_of_interest(_next_priority(owner.ring_vector))



func _next_priority(actor_position: RingVector):
	var next_target = null
	var next_status: int = Constants.Resources.NOTHING
	
	if not _inventory.empty():
		for status in _priorities.keys():
			if _inventory.has(status):
				next_status = status
	
	var priority_list: Array = _priorities.get(next_status, [ ])
	
	
	for target_type in priority_list:
		if not target_type == currently_looking_for.get(TARGET_TYPE):
			var target_priorities: Array = _priorities.get(target_type, [ ])
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



func _construct_priorites():
	_priorities.clear()
	
	for child in get_children():
		_priorities[child.inventory_trigger] = _priorities.get(child.inventory_trigger, [ ]) + child.get_searching_for()
	
	for resource in Constants.Resources.values():
		if resource > Constants.Resources.EVERYTHING:
			_priorities[resource] = _priorities.get(resource, [ ])
			_priorities[resource].append(resource + Constants.REQUEST)




func set_object_of_interest(new_object):
	if not new_object == object_of_interest:
		if object_of_interest:
			object_of_interest.disconnect("died", self, "force_search")
		
		object_of_interest = new_object
		object_of_interest.connect("died", self, "force_search", [false])
		
		emit_signal("new_object_of_interest", object_of_interest)
