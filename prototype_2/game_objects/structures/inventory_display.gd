extends PanelContainer


export(NodePath) var _inventory_node
export var _y_offset: float = 0


onready var _inventory: Inventory = get_node(_inventory_node)



func _ready():
	rect_position.y = _y_offset


func _process(_delta):
	update_display()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_display():
	var display_string: String = "%s:" % [owner.name]
	var content: Dictionary = { }
	
	for item in _inventory.get_children():
		content[Constants.enum_name(Constants.Resources, item.type)] = content.get(item.type, 0) + 1
	
	for item in content.keys():
		display_string += "  %s: %s" % [item, content[item]]
	
	$label.text = display_string
