class_name InventoryHUD
extends Popup


export var _animation_distance: float = 200.0
export var _animation_duration: float = 0.3

var _item_slots: Array
var _tween: Tween



func _enter_tree() -> void:
	var error := Events.hud.connect("inventory_updated", self, "_on_inventory_updated")
	assert(error == OK)
	error = Events.hud.connect("inventory_hud_toggled", self, "_on_inventory_hud_toggled")
	assert(error == OK)
	
	_item_slots = $MarginContainer/GridContainer.get_children()
	_tween = $Tween
	
	for item_slot in _item_slots:
		error = item_slot.connect("item_stack_dropped", self, "_on_item_stack_dropped")
		assert(error == OK)


func _exit_tree() -> void:
	Events.hud.disconnect("inventory_updated", self, "_on_inventory_updated")
	Events.hud.disconnect("inventory_hud_toggled", self, "_on_inventory_hud_toggled")



func _on_inventory_updated(contents: Array) -> void:
	for slot in contents.size():
		var stack: ItemStack = contents[slot]
		
		if stack:
			var item_slot: InventorySlot = _item_slots[slot]
			item_slot.add(stack)
		else:
			var item_slot: InventorySlot = _item_slots[slot]
			item_slot.remove()


func _on_inventory_hud_toggled() -> void:
	if visible:
		_hide_panel()
	else:
		_show_panel()


func _on_item_stack_dropped(item_stack: ItemStack, position: Vector2, sender: InventorySlot) -> void:
	for item_slot in _item_slots:
		if item_slot.get_global_rect().has_point(position):
			if item_slot == sender:
				return
			
			item_slot.add(item_stack)
			sender.remove()
			return


func _show_panel() -> void:
	popup()
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
	hide()
	rect_position.x = previous_position
