class_name RadialMenuRing
extends Control
tool

enum Position { OFF, INSIDE, OUTSIDE }


func draw_item_backgrounds(
		canvas: CanvasItem,
		menu_items: Array,
		selected_item: RadialMenuItem,
		item_angle: float,
		center_offset: Vector2,
		inner: float,
		outer: float,
		start_angle: float,
		count: int
) -> void:
	
	for i in range(count):
		var item: RadialMenuItem = menu_items[i]
		var coords := DrawLibrary.calc_ring_segment(inner, outer, start_angle + i * item_angle, start_angle + (i + 1) * item_angle, center_offset)
		var background_color := _get_color("background")
		var stroke_color := _get_color("background")
		
		if item == selected_item:
			if not item.disabled:
				background_color = _get_color("selected_background")
				stroke_color = _get_color("selected_background")
			else:
				background_color = _get_color("selected_background_disabled")
		elif item.disabled:
			background_color = _get_color("background_disabled")
		
		DrawLibrary.draw_ring_segment(canvas, coords, background_color, stroke_color)


func draw_decorator_ring(
		canvas: CanvasItem,
		decorator_ring_position: int,
		item_angle: float,
		center_offset: Vector2,
		inner: float,
		outer: float,
		start_angle: float,
		count: int
) -> void:
	
	var ring_width: float = _get_constant("decorator_ring_width")
	var coords: PoolVector2Array
	var ring_background_color := _get_color("selected_background")
	
	if decorator_ring_position == Position.OUTSIDE:
		coords = DrawLibrary.calc_ring_segment(outer, outer + ring_width, start_angle, start_angle + count * item_angle, center_offset)
	elif decorator_ring_position == Position.INSIDE:
		coords = DrawLibrary.calc_ring_segment(inner - ring_width, inner, start_angle, start_angle + count * item_angle, center_offset)
	
	DrawLibrary.draw_ring_segment(canvas, coords, ring_background_color)


func draw_selections_ring_segment(
		canvas: CanvasItem,
		menu_items: Array,
		selected_item: RadialMenuItem,
		active_sub_menu: RadialMenuItem,
		selector_position: int,
		item_angle: float,
		center_offset: Vector2,
		inner: float,
		outer: float,
		start_angle: float
) -> void:
	
	if selected_item:# and not active_sub_menu:
		if selected_item.disabled:
			return
		
		var selected := menu_items.find(selected_item)
		var selector_size: float = _get_constant("selector_segment_width")
		var select_coords: PoolVector2Array
		var selector_segment_color := _get_color("selected_background")
		
		if selector_position == Position.OUTSIDE:
			select_coords = DrawLibrary.calc_ring_segment(outer, outer + selector_size, start_angle + selected * item_angle, start_angle + (selected + 1) * item_angle, center_offset)
		elif selector_position == Position.INSIDE:
			select_coords = DrawLibrary.calc_ring_segment(inner - selector_size, inner, start_angle + selected * item_angle, start_angle + (selected + 1) * item_angle, center_offset)
		
		DrawLibrary.draw_ring_segment(canvas, select_coords, selector_segment_color)



func _set_color(color_name: String) -> void:
	set("custom_colors/%s" % color_name, _get_color(color_name))

func _set_constant(constant_name: String) -> void:
	set("constants/%s" % constant_name, _get_constant(constant_name))


func _get_color(color_name: String) -> Color:
	return get_color(color_name, "RadialMenu2")

func _get_constant(constant_name: String):
	return get_constant(constant_name, "RadialMenu2")
