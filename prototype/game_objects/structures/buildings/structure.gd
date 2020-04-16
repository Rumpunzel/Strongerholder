extends CSGMesh


export(NodePath) var hit_box_node

export(Material) var highlight_material



func _ready():
	get_node(hit_box_node).connect("highlighted", self, "handle_highlighted")



func handle_highlighted(highlighted: bool):
	if highlighted and highlight_material:
		material_override = highlight_material
	else:
		material_override = null
