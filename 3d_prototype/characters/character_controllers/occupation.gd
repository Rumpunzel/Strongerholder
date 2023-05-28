class_name Occupation
extends BehaviorTree

export(NodePath) var _character_controller_node
export(NodePath) var _interaction_area_node
export(NodePath) var _inventory_node

onready var _character: Character = owner
onready var _character_controller: CharacterController = get_node(_character_controller_node)
onready var _interaction_area: ObjectTrackingArea = get_node(_interaction_area_node)
onready var _inventory: Inventory = get_node(_inventory_node)
# warning-ignore:unsafe_method_access
onready var _spotted_items: SpottedItems = _character.get_navigation().spotted_items

var _current_job: Workstation.Job = null


func _ready() -> void:
#	# warning-ignore:return_value_discarded
#	_perception_area.connect("body_entered", _spotted_items, "_on_item_approached", [ self ])
#	# warning-ignore:return_value_discarded
#	_perception_area.connect("item_picked_up", _spotted_items, "_on_item_picked_up")
	
	_blackboard = OccupationBlackboard.new(
		self,
		_character,
		_character_controller,
		_interaction_area,
		_inventory,
		_current_job,
		_spotted_items
	)

#func _exit_tree() -> void:
#	_perception_area.disconnect("body_entered", _spotted_items, "_on_item_approached")
#	_perception_area.disconnect("item_picked_up", _spotted_items, "_on_item_picked_up")


func nearest_interactable_target(overwrite_dibs: bool = false) -> CharacterController.Target:
	var nearest: CharacterController.Target = null
	var closest_distance: float = INF
	
	for object in _interaction_area.objects_in_area:
		# warning-ignore:unsafe_property_access
		if not object or object == owner or object.owner == owner or (not overwrite_dibs and object.has_method("is_dibbable") and not object.is_dibbable(self)):
			continue
		
		var potential_interaction := determine_potential_interaction(object)
		if not potential_interaction:
			continue
		
		var distance := _character.translation.distance_squared_to(object.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			nearest = potential_interaction
	
	return nearest

func determine_potential_interaction(object: Node) -> CharacterController.Target:
	return _character_controller.get_potential_interaction(object)
