class_name GameMesh
extends CSGMesh


export(NodePath) var hit_box_node

export(Material) var highlight_material: Material
export(Material) var placement_material: Material


var placed: bool = false


onready var hit_box: StructureHitBox = get_node(hit_box_node)




func _ready():
	owner.connect("activate", self, "initialize")
	hit_box.connect("highlighted", self, "handle_highlighted")
	
	material_override = placement_material


func _process(_delta):
	if not placed and material_override:
		material_override.set_shader_param("is_invalid", hit_box.is_blocked())





func initialize():
	placed = true
	
	if material_override == placement_material:
		material_override = null
	
	set_process(false)


func handle_highlighted(highlighted: bool):
	if highlighted and highlight_material:
		material_override = highlight_material
	else:
		material_override = null
