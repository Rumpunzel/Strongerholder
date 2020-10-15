class_name CityStructure, "res://assets/icons/structures/icon_city_structure.svg"
extends GameObject


export(Constants.Structures) var type: int


onready var _inventory: StructureInventory = $inventory




func _ready():
	add_to_group(Constants.enum_name(Constants.Structures, type))




func die():
	_inventory.drop_all_items()
	print("%s died." % [name])
	.die()
