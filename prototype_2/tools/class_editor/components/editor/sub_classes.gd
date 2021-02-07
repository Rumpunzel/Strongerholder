extends TabContainer



func update_all_data() -> void:
	for tab in get_children():
		tab.update_list()
