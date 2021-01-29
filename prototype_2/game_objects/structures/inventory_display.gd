extends PanelContainer


export(NodePath) var _inventory_node
export var _y_offset: float = 0


onready var _inventory: Inventory = get_node(_inventory_node)



func _ready() -> void:
	rect_position.y = _y_offset


func _process(_delta) -> void:
	update_display()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_display() -> void:
	var display_string: String = "%s: " % [owner.name]
	var content: Dictionary = { }
	
	for item in _inventory.get_contents() -> void:
		content[item.type] = content.get(item.type, 0) + 1
	
	for item in content.keys() -> void:
		display_string += "%s: %s " % [Constants.enum_name(Constants.Resources, item), content[item]]
	
	$label.text = display_string
