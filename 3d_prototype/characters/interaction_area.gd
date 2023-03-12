class_name InteractionArea, "res://editor_tools/class_icons/spatials/icon_slap.svg"
extends AreaTrackingArea

signal item_picked_up(item)
signal gave_item(item, amount)
signal took_item(item, amount)
signal operated()


onready var _character: Spatial = owner
# warning-ignore:unsafe_method_access
onready var _spotted_items: SpottedItems = _character.get_navigation().spotted_items


func _ready() -> void:
	# warning-ignore:return_value_discarded
	connect("item_picked_up", _spotted_items, "_on_item_picked_up")

func _exit_tree() -> void:
	disconnect("item_picked_up", _spotted_items, "_on_item_picked_up")


func get_potential_interaction(object: Node, inventory: CharacterInventory) -> CharacterController.ItemInteraction:
	var interaction_resource: ItemResource = null
	var can_stash := false
	
	# HACK: access to private member
	if object is Stash and not (object as Stash).full(object._item_to_store):
		var stash: Stash = object
		if not inventory:
			can_stash = true
		else:
			for stack in inventory.contents(false):
				var item: ItemResource = stack.item
				if stash.stores(item):
					can_stash = true
					interaction_resource = item
					break
	
	if object is CollectableItem:
		return CharacterController.ItemInteraction.new(object, CharacterController.ObjectInteraction.InteractionType.PICK_UP, interaction_resource, 1)
	
	if object is Stash and can_stash:
		return CharacterController.ItemInteraction.new(object, CharacterController.ObjectInteraction.InteractionType.GIVE, interaction_resource, 1)
	
	if object is Workstation and (object as Workstation).can_be_operated():
		return CharacterController.ItemInteraction.new(object, CharacterController.ObjectInteraction.InteractionType.OPERATE, interaction_resource, 1)
	
	return null

func pick_up(item_node: CollectableItem) -> void:
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore:unsafe_property_access
	var item: ItemResource = item_node.item_resource
	emit_signal("item_picked_up", item)
	# TODO: properly destroy item instead of only freeing
	item_node.queue_free()

func give(stash: Stash, item: ItemResource, amount: int) -> void:
	# warning-ignore:return_value_discarded
	stash.stash(item, amount)
	emit_signal("gave_item", item, amount)

func operate(workstation: Workstation) -> void:
	workstation.operate()
	emit_signal("operated")

func take(stash: Stash, item: ItemResource, amount: int) -> void:
	# warning-ignore:return_value_discarded
	stash.take(item, amount)
	emit_signal("took_item", item, amount)
