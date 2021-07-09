extends RadialMenu2
tool


export(PackedScene) var _item_scene: PackedScene = null


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_items := [ ]
	for _i in range(5):
		var new_item: InventoryHUDItem = _item_scene.instance()
		new_item.configure(load("res://icon.png"), 1)
		new_items.append(new_item)
	
	_set_items(new_items)
	call_deferred("open_menu")

