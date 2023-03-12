class_name HurtBox, "res://editor_tools/class_icons/spatials/icon_pierced_heart.svg"
extends ObjectTrackingArea

signal attacked(started)

var _equipped_item: CharacterInventory.EquippedItem

onready var _character: Spatial = owner
# warning-ignore:unsafe_method_access
onready var _hurt_box_shape: CollisionShape = $CollisionShape


func can_attack_object(object: Node) -> bool:
	var interaction_resource: ItemResource = null
	var can_stash := false

	if object is HitBox and _equipped_item:
		var equipped_tool: ToolResource = _equipped_item.stack.item
		# WAITFORUPDATE: remove this unnecessary thing after 4.0
		# warning-ignore:unsafe_property_access
		# HACK: fix this ugly implementation
		if object.owner is Structure and object.owner.structure_resource == equipped_tool.used_on:
			return true

	return false

func attack(started: bool) -> void:
	if started:
		for object in objects_in_area:
			_damage_hit_box(object)
	emit_signal("attacked", started)


func _damage_hit_box(node: Node) -> void:
	if not node is HitBox:
		return
	
	var hit_box := node as HitBox
	var equipped_tool: ToolResource = _equipped_item.stack.item
	
	# HACK: fix this ugly implementation
	# warning-ignore-all:unsafe_property_access
	if hit_box.owner is Structure and hit_box.owner.structure_resource == equipped_tool.used_on:
		# warning-ignore:return_value_discarded
		hit_box.damage(equipped_tool.damage, self)


func _on_item_equipped(equipment: CharacterInventory.EquippedItem):
	_equipped_item = equipment

func _on_item_unequipped(equipment: CharacterInventory.EquippedItem):
	if _equipped_item == equipment:
		_equipped_item = null
