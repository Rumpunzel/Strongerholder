class_name HurtBox, "res://editor_tools/class_icons/spatials/icon_pierced_heart.svg"
extends ObjectTrackingArea

onready var _character: Spatial = owner
# warning-ignore:unsafe_method_access
onready var _hurt_box_shape: CollisionShape = $CollisionShape


func can_attack_object(object: Node, equipped_item: CharacterInventory.EquippedItem) -> bool:
	var interaction_resource: ItemResource = null
	var can_stash := false
	
	if object is HitBox and equipped_item:
		var equipped_tool: ToolResource = equipped_item.stack.item
		# WAITFORUPDATE: remove this unnecessary thing after 4.0
		# warning-ignore:unsafe_property_access
		# HACK: fix this ugly implementation
		if object.owner is Structure and object.owner.structure_resource == equipped_tool.used_on:
			return true
	
	return false


func damage_hit_boxes(equipped_item: CharacterInventory.EquippedItem) -> void:
	for object in objects_in_area:
		if not object is HitBox:
			continue
		damage_hit_box(object, equipped_item)

func damage_hit_box(hit_box: HitBox, equipped_item: CharacterInventory.EquippedItem) -> void:
	var equipped_tool: ToolResource = equipped_item.stack.item
	
	# HACK: fix this ugly implementation
	# warning-ignore-all:unsafe_property_access
	if hit_box.owner is Structure and hit_box.owner.structure_resource == equipped_tool.used_on:
		# warning-ignore:return_value_discarded
		hit_box.damage(equipped_tool.damage, self)
