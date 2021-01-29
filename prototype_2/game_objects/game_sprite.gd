class_name GameSprite
extends Sprite


export(NodePath) var _hit_box_node

export(Material) var _highlight_material: Material



#func _ready() -> void:
#	get_node(_hit_box_node).connect("highlighted", self, "handle_highlighted")



func handle_highlighted(highlighted: bool) -> void:
	pass
#	if highlighted and _highlight_material:
#		material_override = _highlight_material
#	else:
#		material_override = null
