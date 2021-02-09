extends TabContainer




func add_sheets(new_sheets: Array) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	
	if new_sheets.empty():
		new_sheets.append("res://assets/sprites/icon.png")
	
	var counter := 1
	
	for sheet in new_sheets:
		var new_sprite := TextureRect.new()
		
		new_sprite.name = "sprite_sheet%s" % (("_%d" % counter) if counter > 1 else "")
		new_sprite.size_flags_horizontal = SIZE_EXPAND_FILL
		new_sprite.size_flags_vertical = SIZE_EXPAND_FILL
		new_sprite.expand = true
		new_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		new_sprite.texture = load(sheet)
		
		add_child(new_sprite)
		
		new_sprite.call_deferred("set_custom_minimum_size", Vector2(max(new_sprite.rect_size.x, new_sprite.rect_size.y), new_sprite.rect_min_size.y))
		
		counter += 1
