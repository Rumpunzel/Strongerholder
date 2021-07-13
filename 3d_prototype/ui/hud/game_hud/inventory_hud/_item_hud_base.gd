class_name ItemHUDBASE
extends RadialMenu

export(PackedScene) var _item_scene: PackedScene = null            

var _inventory: CharacterInventory
var _items := [ ]


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	connect("item_selected", self, "_on_item_selected")
	# warning-ignore:return_value_discarded
	Events.main.connect("game_paused", self, "close_menu")

func _exit_tree() -> void:
	Events.main.disconnect("game_paused", self, "close_menu")
	
	_free_items()


func _on_toggled(new_inventory: CharacterInventory) -> void:
	if not _inventory == new_inventory:
		_initialize_items(new_inventory)


func _on_inventory_stacks_updated(new_inventory: CharacterInventory) -> void:
	if not _inventory == new_inventory:
		_initialize_items(new_inventory)


func _initialize_items(new_inventory: CharacterInventory) -> void:
#	if _inventory:
#		for child in get_children():
#			remove_child(child)
#			child.queue_free()
	
	_free_items()
	
	_inventory = new_inventory
	
	for _i in _inventory.size():
		var new_item: InventoryHUDItem = _item_scene.instance()
		new_item.item_stack = null
		_items.append(new_item)

func _free_items() -> void:
	for item in _items:
		item.queue_free()
	_items.clear()
