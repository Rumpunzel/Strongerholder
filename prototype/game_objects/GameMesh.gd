class_name GameMesh
extends CSGMesh


export(NodePath) var _hit_box_node

export(Material) var _highlight_material: Material
export(Material) var _placement_material: Material


var _placed: bool = false


onready var _hit_box: StructureHitBox = get_node(_hit_box_node)




func _ready():
	owner.connect("activate", self, "initialize")
	_hit_box.connect("highlighted", self, "handle_highlighted")
	
	material_override = _placement_material


func _process(_delta):
	if not _placed and material_override:
		material_override.set_shader_param("is_invalid", _hit_box.is_blocked())





func initialize():
	_placed = true
	
	if material_override == _placement_material:
		material_override = null
	
	set_process(false)


func handle_highlighted(highlighted: bool):
	if highlighted and _highlight_material:
		material_override = _highlight_material
	else:
		material_override = null
