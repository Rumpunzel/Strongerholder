extends CSGMesh


export(Material) var highlight_material


func handle_highlighted(highlighted: bool):
	if highlighted and highlight_material:
		material_override = highlight_material
	else:
		material_override = null
