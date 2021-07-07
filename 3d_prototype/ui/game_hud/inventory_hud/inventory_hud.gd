class_name InventoryHUD
extends PanelContainer


export var _animation_distance: float = 200.0
export var _animation_duration: float = 0.3

onready var _item_slots := $GridContainer.get_children()
onready var _tween: Tween = $Tween



func _ready():
	var error := Events.hud.connect("inventory_updated", self, "_on_inventory_updated")
	assert(error == OK)
	error = Events.hud.connect("inventory_hud_toggled", self, "_on_inventory_hud_toggled")
	assert(error == OK)
	
	visible = false



func _on_inventory_updated(inventory: Inventory) -> void:
	var contents := inventory.contents(false)
	for slot in contents.size():
		var stack: ItemStack = contents[slot]
		
		if stack:
			var item_slot: ItemSlot = _item_slots[slot]
			item_slot.add(stack)
		else:
			var item_slot: ItemSlot = _item_slots[slot]
			item_slot.remove()


func _on_inventory_hud_toggled() -> void:
	if visible:
		_hide_panel()
	else:
		_show_panel()


func _show_panel() -> void:
	visible = true
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate:a", 0.0, 1.0, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "rect_position:x", rect_position.x - _animation_distance, rect_position.x, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.start()


func _hide_panel() -> void:
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate:a", 1.0, 0.0, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_IN)
	var previous_position := rect_position.x
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "rect_position:x", previous_position, previous_position - _animation_distance, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_IN)
	# warning-ignore:return_value_discarded
	_tween.start()
	yield(_tween, "tween_all_completed")
	visible = false
	rect_position.x = previous_position
