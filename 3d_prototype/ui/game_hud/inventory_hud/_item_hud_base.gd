class_name ItemHUDBASE
extends RadialMenu

# warning-ignore:unused_class_variable
export(PackedScene) var _item_scene: PackedScene = null   
export(Texture) var _unequip_icon            

var _inventory: CharacterInventory
var _unequip: ItemStack


func _enter_tree() -> void:            
	var error = Events.main.connect("game_paused", self, "close_menu")
	assert(error == OK)
	
	var unequip_resource := ToolResource.new()
	# TODO: remove this unnecessary thing after 4.0
	# warning-ignore-all:unsafe_property_access
	unequip_resource.icon = _unequip_icon
	_unequip = ItemStack.new(unequip_resource)

func _exit_tree() -> void:
	Events.main.disconnect("game_paused", self, "close_menu")


func _equip_item_from_stack(stack: ItemStack) -> void:
	var equipped := stack == _unequip
	if not equipped:
		_inventory.equip_item_from_stack(stack)
	else:
		# warning-ignore:return_value_discarded
		_inventory.unequip()
