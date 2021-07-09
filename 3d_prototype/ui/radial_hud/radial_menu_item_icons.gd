class_name RadialMenuItemIcons
extends Control
tool


func update_item_icon(
		menu_items: Array,
		selected_item: RadialMenuItem,
		count: int
) -> void:
	
	var items := get_children()
	for i in range(count):
		var item: RadialMenuItem = menu_items[i]
		var icon_modulate := _get_color("icon_modulate_disabled")
		
		if not item.disabled:
			if item == selected_item:
				icon_modulate = _get_color("icon_modulate_selected")
				item.highlight(true)
			else:
				icon_modulate = _get_color("icon_modulate")
				item.highlight(false)
		
		var item_node: RadialMenuItem = items[i]
		item_node.modulate = icon_modulate


func create_item_icons(
		menu_items: Array,
		center_angle: float,
		item_angle: float,
		icon_radius: float,
		center_offset: Vector2,
		icon_size: Vector2
) -> void:
	
	assert(is_inside_tree())
	clear_items()
	
	var item_count := menu_items.size()
	if item_count == 0:
		return
	
	var start_angle := center_angle - item_angle * (item_count >> 1) 
	var half_angle: float
	
	if item_count % 2 == 0:
		half_angle = item_angle / 2.0
	else:
		half_angle = 0.0
	
	var coords := DrawLibrary.calc_ring_segment_centers(icon_radius, item_count, start_angle + half_angle, start_angle + half_angle + item_count * item_angle, center_offset)
	
	for i in menu_items.size():
		var item_node: RadialMenuItem = menu_items[i]
		add_child(item_node)
		item_node.rect_min_size = icon_size
		item_node.rect_position = coords[i] - icon_size / 2.0


func update_item_nodes(
		menu_items: Array,
		center_angle: float,
		item_angle: float,
		icon_radius: float,
		center_offset: Vector2,
		icon_size: Vector2
) -> void:
	
	if get_children().empty():
		create_item_icons(menu_items, center_angle, item_angle, icon_radius, center_offset, icon_size)
		return
	
	var item_count := menu_items.size()
	#var icon_radius := _get_icon_radius()
	var start_angle := center_angle - item_angle * item_count * 0.5 + item_angle * 0.5
	
	var coords := DrawLibrary.calc_ring_segment_centers(icon_radius, item_count,  start_angle, start_angle + item_count * item_angle, center_offset)
	var item_nodes := get_children()
	var node_index := 0
	
	for i in range(item_count):
		var item = menu_items[i]
		if item != null:
			var item_node = item_nodes[node_index]
			node_index += 1
			item_node.rect_min_size = icon_size
			item_node.rect_position = coords[i] - icon_size / 2.0


func clear_items() -> void:
	assert(is_inside_tree())
	for node in get_children():
		remove_child(node)



func _set_color(color_name: String) -> void:
	set("custom_colors/%s" % color_name, _get_color(color_name))

func _set_constant(constant_name: String) -> void:
	set("constants/%s" % constant_name, _get_constant(constant_name))


func _get_color(color_name: String) -> Color:
	return get_color(color_name, "RadialMenu2")

func _get_constant(constant_name: String):
	return get_constant(constant_name, "RadialMenu2")
