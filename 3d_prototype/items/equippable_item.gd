class_name EquippableItem
extends Spatial

export(Resource) var item_resource

onready var _hurt_shape: CollisionShape = $HurtBox/CollisionShape


func attack(started: bool) -> void:
	_hurt_shape.disabled = not started


func _on_hurt_box_entered(area: Area) -> void:
	if not area is HitBox:
		return
	
	var hit_box := area as HitBox
	for other_group in hit_box.owner.get_groups():
		if item_resource.used_on.has(other_group):
			# warning-ignore:return_value_discarded
			hit_box.damage(item_resource.damage, self)


func _get_configuration_warning() -> String:
	var warning := ""
	
	# Data
	if not item_resource:
		warning = "ItemResource is required"
	elif not item_resource is ItemResource:
		warning = "ItemResource is of the wrong type"
	
	return warning
