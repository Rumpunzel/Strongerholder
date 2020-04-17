extends PanelContainer


export(NodePath) var _inventory_node
export var _y_offset: float = 0


onready var _inventory: Inventory = get_node(_inventory_node)



func _ready():
	_inventory.connect("received_item", self, "update_display")
	_inventory.connect("sent_item", self, "update_display")
	
	rect_position.y = _y_offset
	update_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_display(_new_item = null):
	var display_string: String = "%s: " % [owner.name]
	var types_displayed: Array = [ ]
	
	_inventory.contents.sort()
	
	for item in _inventory.contents:
		if not types_displayed.has(item):
			display_string += "  %s: %s" % [Constants.enum_name(Constants.Resources, item), _inventory.contents.count(item)]
			types_displayed.append(item)
	
	$label.text = display_string
