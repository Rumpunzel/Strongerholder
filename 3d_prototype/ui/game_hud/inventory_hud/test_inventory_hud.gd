extends RadialMenu2
tool

export(PackedScene) var _item_scene: PackedScene = null


# Called when the node enters the scene tree for the first time.
func _ready():
	return
	var new_items := [ ]
	for i in range(5):
		var new_item: InventoryHUDItem = _item_scene.instance()
		new_item.texture = load("res://icon.png")
		new_item.amount = i + 1
		
		var new_sub_new_items := [ ]
		for j in range(3):
			var sub_new_item: InventoryHUDItem = _item_scene.instance()
			sub_new_item.texture = load("res://icon.png")
			sub_new_item.amount = j + 1
			new_sub_new_items.append(sub_new_item)
		
		new_item.submenu_items = new_sub_new_items
		new_items.append(new_item)
	
	_set_items(new_items)
	call_deferred("open_menu", get_viewport_rect().size / 2.0)

