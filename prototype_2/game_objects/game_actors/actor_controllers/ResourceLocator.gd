class_name ResourceLocator, "res://assets/icons/game_actors/icon_resource_locator.svg"
extends Node2D


signal new_object_of_interest(object_of_interest)


const TARGET_TYPE: String = "target_type"
const TARGET_RESOURCE: String = "target_resource"


export(NodePath) var _inventory_node
export(NodePath) var _tool_belt_node
export(NodePath) var _animation_player_node
export(NodePath) var _animation_tree_node


var object_of_interest = null setget set_object_of_interest
var currently_looking_for: Dictionary = { }


var _priorities: Dictionary = { }


onready var _inventory: Inventory = get_node(_inventory_node)
onready var _tool_belt = get_node(_tool_belt_node)
onready var _animation_player: AnimationPlayer = get_node(_animation_player_node)
onready var _animation_tree: AnimationStateMachine = get_node(_animation_tree_node)




func _ready():
	_construct_priorites()
	yield(get_tree(), "idle_frame")
	force_search()
	
	#RingMap.connect("city_changed", self, "force_search")
	#RingMap.connect("resources_changed", self, "force_search", [false, true])




func interact_with(other_hit_box: ObjectHitBox, own_hit_box: ActorHitBox):
	if other_hit_box:
		var craft_tool: CraftTool = _tool_belt.has_tool_for_this(other_hit_box)
		
		var target_type = currently_looking_for.get(TARGET_TYPE)
		var target_resource = currently_looking_for.get(TARGET_RESOURCE)
		
		
		if craft_tool:
			_animation_tree.travel(craft_tool.animation)
			
			yield(_animation_player, "acted")
			
			craft_tool.interact_with(other_hit_box, own_hit_box, _tool_belt)
			
		elif target_resource is String and not target_resource == "Empty":
			if target_resource.begins_with("Request_"):
				target_resource = target_resource.trim_prefix()
			
			set_object_of_interest(null)
			_animation_tree.travel("give")
			
			yield(_animation_player, "acted")
			
			own_hit_box.offer_item(target_resource, other_hit_box)
			force_search()
			
		elif target_type and GameResource.RESOURCES.has(target_type):
			set_object_of_interest(null)
			_animation_tree.travel("give")
			
			yield(_animation_player, "acted")
			
			var other_object = other_hit_box.owner
			
			if other_object is GameResource:
				if other_object.get_parent():
					other_object.get_parent().remove_child(other_object)
				
				_inventory.add_child(other_object)
				other_object.global_position = owner.global_position
			else:
				own_hit_box.request_item(target_type, other_hit_box)
			
			force_search()



func force_search(reset_target_type: bool = true, super_soft_reset: bool = false):
	if not super_soft_reset or currently_looking_for.empty():
		if reset_target_type:
			currently_looking_for = { }
		
		set_object_of_interest(_next_priority())




func _next_priority():
	var next_target = null
	var next_status: String = "Empty"
	
	# Check for a target in range
	for spyglass in get_children():
		next_target = spyglass.search_for_target(_inventory)
		
		if next_target:
			break
	
	# Then get the corresponding spyglass's priority list
	var priority_list: Array = _priorities.get(next_status, [ ])
	
	
	for target_type in priority_list:
		if not target_type == currently_looking_for.get(TARGET_TYPE):
			var target_priorities: Array = _priorities.get(target_type, [ ])
			var dictionary: Dictionary = { }
			var targets_exists: bool = true
			
			
			if target_type is String and target_type.begins_with("Request_"):
				pass#dictionary = RingMap.resources.dictionary
				
			elif GameResource.RESOURCES.has(target_type):
				#dictionary = RingMap.resources.dictionary
				targets_exists = false
				
				for prio in target_priorities:
#					if RingMap.structures.dictionary.has(prio) or RingMap.resources.dictionary.has(prio):
#						targets_exists = true
#						break
					pass
			else:
				pass#dictionary = RingMap.structures.dictionary
			
			
			if targets_exists:
				pass#next_target = RingMap.city_navigator.get_nearest(dictionary, target_type, actor_position, target_priorities, owner, _tool_belt.valid_targets())
			
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
	
	for spyglass in get_children():
		_priorities[spyglass.inventory_trigger] = _priorities.get(spyglass.inventory_trigger, [ ]) + spyglass.get_searching_for()
	
	for resource in GameResource.RESOURCES:
		_priorities[resource] = _priorities.get(resource, [ ])
		_priorities[resource].append("%s%s" % [GameResource.REQUEST, resource])




func set_object_of_interest(new_object):
	if not new_object == object_of_interest:
		if not new_object is GameResource or not new_object.called_dibs_by or new_object.called_dibs_by == owner:
			if weakref(object_of_interest).get_ref():
				if object_of_interest is GameResource and new_object is GameResource:
					object_of_interest.called_dibs_by = null
				
				object_of_interest.disconnect("died", self, "force_search")
			
			object_of_interest = new_object
			
			if object_of_interest:
				if object_of_interest is GameResource:
					object_of_interest.called_dibs_by = owner
				
				object_of_interest.connect("died", self, "force_search")
			print("new object of interest: %s" % [object_of_interest.name if object_of_interest else "nothing"])
			emit_signal("new_object_of_interest", object_of_interest)
		else:
			force_search(false)
