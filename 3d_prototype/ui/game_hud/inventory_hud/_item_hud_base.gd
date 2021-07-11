class_name ItemHUDBASE
extends RadialMenu


export(PackedScene) var _item_scene: PackedScene = null   
export(Texture) var _unequip_icon            

var _inventory: CharacterInventory
var _items := [ ]
var _unequip: ItemStack



func _enter_tree() -> void:
	var error := connect("item_selected", self, "_on_item_selected")
	assert(error == OK)
		
	error = Events.main.connect("game_paused", self, "close_menu")
	assert(error == OK)
	
	var unequip_resource := ToolResource.new()
	# WAITFORUPDATE: remove this unnecessary thing after 4.0
	# warning-ignore-all:unsafe_property_access
	unequip_resource.icon = _unequip_icon
	_unequip = ItemStack.new(unequip_resource)

func _exit_tree() -> void:
	Events.main.disconnect("game_paused", self, "close_menu")



func _on_toggled(new_inventory: CharacterInventory) -> void:
	if not _inventory == new_inventory:
		_initialize_items(new_inventory)


func _on_inventory_updated(new_inventory: CharacterInventory) -> void:
	if not _inventory == new_inventory:
		_initialize_items(new_inventory)


func _initialize_items(new_inventory: CharacterInventory) -> void:
	if _inventory:
		for child in get_children():
			remove_child(child)
			child.queue_free()
	
	_inventory = new_inventory
	
	for _i in _inventory.size():
		var new_item: InventoryHUDItem = _item_scene.instance()
		new_item.item_stack = null
		_items.append(new_item)
	
	_set_items(_items)


func _equip_item_from_stack(stack: ItemStack) -> void:
	var equipped := stack == _unequip
	if not equipped:
		_inventory.equip_item_from_stack(stack)
	else:
		# warning-ignore:return_value_discarded
		_inventory.unequip()
