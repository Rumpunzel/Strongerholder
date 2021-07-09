class_name DrawLibrary


static func calc_circle_coordinates(radius: float, points_to_calculate: int, angle_offset := 0.0, offset := Vector2.ZERO) -> PoolVector2Array:
	"""
	Calculates <points_to_calculate> coordinates on a circle with a given <radius>.
	The first point lies at 12 o'clock unless you specify an <angle_offset>
	(in radians)
	
	Returns a PoolVector2Array with the coordinates.
	"""
	var coords := PoolVector2Array()
	var angle := TAU / float(points_to_calculate)
	
	for i in range(points_to_calculate):
		var x := radius * sin(angle_offset + i * angle)
		var y := radius * cos(angle_offset + i * angle)
		coords.append(Vector2(x, y) + offset)
	
	return coords


static func calc_arc_AABB(radius: float, start_angle: float, end_angle: float, center := Vector2.ZERO) -> Rect2:
	"""
	Calculates the Axis-Aligned Bounding Box of the arc defined by the parameters.
	"""
	if end_angle-start_angle >= TAU:
		return Rect2(center.x - radius, center.y - radius, 2.0 * radius, 2.0 * radius)
	
	start_angle = fposmod(start_angle, TAU)
	end_angle = fposmod(end_angle, TAU)
	
	var ps := Vector2(radius * cos(start_angle), radius * sin(start_angle))
	var pe := Vector2(radius * cos(end_angle), radius * sin(end_angle))
	
	var min_x := 0.0
	var max_x := 0.0
	var min_y := 0.0
	var max_y := 0.0
	
	if fposmod(start_angle - PI, TAU) > fposmod(end_angle - PI, TAU):
		min_x = -radius
	
	if start_angle > end_angle:
		max_x = radius
	
	if fposmod(start_angle - PI * 1.5, TAU) > fposmod(end_angle - PI * 1.5, TAU):
		min_y = -radius
	
	if fposmod(start_angle - PI * 0.5, TAU) > fposmod(end_angle - PI * 0.5, TAU):
		max_y = radius
	
	if min_x == 0.0:
		min_x = min(ps.x, pe.x)
	if max_x == 0.0:
		max_x = max(ps.x, pe.x)
	if min_y == 0.0:
		min_y = min(ps.y, pe.y)
	if max_y == 0.0:
		max_y = max(ps.y, pe.y)
	
	return Rect2(min_x + center.x, min_y + center.y, max_x - min_x, max_y - min_y)


static func calc_ring_segment(inner_radius: float, outer_radius: float, start_angle: float, end_angle: float, offset := Vector2.ZERO) -> PoolVector2Array:
	"""
	Calculates the coordinates of a ring segment
	"""
	var coords := PoolVector2Array()
	var fraction_of_full := (end_angle - start_angle) / TAU
	var nopoints := int(max(2, int(outer_radius * fraction_of_full)))
	var nipoints := int(max(2, int(inner_radius * fraction_of_full)))
	var angle = (end_angle - start_angle) / float(nopoints)
	
	for i in range(nopoints + 1):
		var x := outer_radius * sin(start_angle + i * angle)
		var y := outer_radius * cos(start_angle + i * angle)
		coords.append(Vector2(x, y) + offset)
	
	angle = (end_angle - start_angle) / float(nipoints)
	
	for i in range(nipoints + 1):
		var x := inner_radius * sin(end_angle - i * angle)
		var y := inner_radius * cos(end_angle - i * angle)
		coords.append(Vector2(x, y) + offset)
	
	return coords


static func calc_ring_segment_centers(radius: float, points_to_calculate: int, start_angle: float, end_angle: float, offset := Vector2.ZERO) -> PoolVector2Array:
	var coords := PoolVector2Array()
	var angle := (end_angle - start_angle) / float(points_to_calculate)
	
	for i in range(points_to_calculate):
		var x := radius * sin(start_angle + i * angle)
		var y := radius * cos(start_angle + i * angle)
		coords.append(Vector2(x, y) + offset)
	
	return coords


static func calc_ring_segment_AABB(inner: float, outer: float, start_angle: float, end_angle: float, center := Vector2.ZERO) -> Rect2:
	"""
	Calculates the axis-aligned bounding box of a ring segment
	"""
	var inner_aabb := calc_arc_AABB(inner, start_angle, end_angle, center)
	var outer_aabb := calc_arc_AABB(outer, start_angle, end_angle, center)
	
	return inner_aabb.merge(outer_aabb)


static func draw_ring_segment(canvas : CanvasItem, coords : PoolVector2Array, fill_color: Color, stroke_color := Color.transparent, width := 1.0, antialiased := true) -> void:
	"""
	Draws a segment of a ring. The ring coordinates must be passed in; they can be generated with calc_ring_segment.
	"""
	if coords.empty():
		return
	
	if not fill_color == Color.transparent:
		canvas.draw_colored_polygon(coords, fill_color, PoolVector2Array(), null, null, antialiased)
	
	if not stroke_color == Color.transparent:
		canvas.draw_polyline(coords, stroke_color, width, antialiased)
		canvas.draw_line(coords[-1], coords[0], stroke_color, width, antialiased)


static func draw_ring(canvas : CanvasItem, inner_radius : float, outer_radius : float, fill_color: Color, stroke_color := Color.transparent, width := 1.0, antialiased := true, offset := Vector2.ZERO) -> void:
	"""
	Draws a ring.
		
	Caveat: If you draw an antialiased ring with a partially transparent fill_color
			without a stroke, you will get an ugly seam where the polygon joins
			itself.
	"""
	var coords_inner := PoolVector2Array()
	var coords_outer := PoolVector2Array()
	var coords_all := PoolVector2Array()
	
	var nopoints := int(max(2, int(outer_radius)))
	var nipoints := int(max(2, int(inner_radius)))
	var angle := TAU / float(nopoints)
	
	for i in range(nopoints + 1):
		var x := outer_radius * sin(i * angle)
		var y := outer_radius * cos(i * angle)
		var v := Vector2(x, y)
		
		coords_outer.append(v + offset)
		coords_all.append(v + offset)
	
	angle = TAU / float(nipoints)
	
	for i in range(nipoints + 1):
		var x := inner_radius * sin(TAU - i * angle)
		var y := inner_radius * cos(TAU - i * angle)
		var v := Vector2(x, y)
		
		coords_inner.append(v + offset)
		coords_all.append(v + offset)
	
	if not stroke_color == Color.transparent:
		canvas.draw_colored_polygon(coords_all, fill_color, PoolVector2Array(), null, null, false)
		
		canvas.draw_polyline(coords_inner, stroke_color, width, antialiased)
		canvas.draw_polyline(coords_outer, stroke_color, width, antialiased)
