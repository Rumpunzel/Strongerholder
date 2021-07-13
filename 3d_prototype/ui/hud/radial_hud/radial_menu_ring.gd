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
		clock_wise: bool,
		count: int
) -> void:
	
	for i in range(count):
		var item: RadialMenuItem = menu_items[i]
		var adjusted_start_angle := start_angle + (i + (1 if clock_wise else 0)) * item_angle
		var end_angle := start_angle + (i + (0 if clock_wise else 1)) * item_angle
		var coords := DrawLibrary.calc_ring_segment(inner, outer, adjusted_start_angle, end_angle, center_offset)
		
		var background_color := _get_color("background")
		var stroke_color := Color.transparent
		var stroke_width := 1.0
		
		if item == selected_item:
			if item.disabled:
				background_color = _get_color("selected_background_disabled")
				stroke_color = background_color
			elif item.is_modified():
				background_color = _get_color("selected_background_disabled")
				stroke_color = _get_color("selected_background")
				stroke_width = _get_constant("equipped_stroke_width_selected")
			else:
				background_color = _get_color("selected_background")
		else:
			if item.disabled:
				background_color = _get_color("background_disabled")
				stroke_color = background_color
			elif item.is_modified():
				background_color = _get_color("selected_background_disabled")
				stroke_color = _get_color("selected_background")
				stroke_width = _get_constant("equipped_stroke_width")
		
		DrawLibrary.draw_ring_segment(canvas, coords, background_color, stroke_color, stroke_width)


func draw_decorator_ring(
		canvas: CanvasItem,
		decorator_ring_position: int,
		item_angle: float,
		center_offset: Vector2,
		inner: float,
		outer: float,
		start_angle: float,
		clock_wise: bool,
		count: int
) -> void:
	
	var ring_width: float = _get_constant("decorator_ring_width")
	var coords: PoolVector2Array
	var ring_background_color := _get_color("selected_background")
	
	var inner_radius: float
	var outer_radius: float
	var adjusted_start_angle := start_angle + (count * item_angle if clock_wise else 0.0)
	var end_angle := start_angle + (0.0 if clock_wise else count * item_angle)
	
	if decorator_ring_position == Position.OUTSIDE:
		inner_radius = outer
		outer_radius = outer + ring_width
	elif decorator_ring_position == Position.INSIDE:
		inner_radius = inner - ring_width
		outer_radius = inner
		
	coords = DrawLibrary.calc_ring_segment(inner_radius, outer_radius, adjusted_start_angle, end_angle, center_offset)
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
		start_angle: float,
		clock_wise: bool
) -> void:
	
	if selected_item and not active_sub_menu:
		if selected_item.disabled:
			return
		
		var selected := menu_items.find(selected_item)
		var selector_size: float = _get_constant("selector_segment_width")
		var select_coords: PoolVector2Array
		var selector_segment_color := _get_color("selected_background")
		
		var adjusted_start_angle := start_angle + (selected + (1 if clock_wise else 0)) * item_angle
		var end_angle := start_angle + (selected + (0 if clock_wise else 1)) * item_angle
		
		if selector_position == Position.OUTSIDE:
			select_coords = DrawLibrary.calc_ring_segment(outer, outer + selector_size, adjusted_start_angle, end_angle, center_offset)
		elif selector_position == Position.INSIDE:
			select_coords = DrawLibrary.calc_ring_segment(inner - selector_size, inner, adjusted_start_angle, end_angle, center_offset)
		
		DrawLibrary.draw_ring_segment(canvas, select_coords, selector_segment_color)



func _set_color(color_name: String) -> void:
	set("custom_colors/%s" % color_name, _get_color(color_name))

func _set_constant(constant_name: String) -> void:
	set("constants/%s" % constant_name, _get_constant(constant_name))


func _get_color(color_name: String) -> Color:
	return get_color(color_name, "RadialMenu")

func _get_constant(constant_name: String):
	return get_constant(constant_name, "RadialMenu")
