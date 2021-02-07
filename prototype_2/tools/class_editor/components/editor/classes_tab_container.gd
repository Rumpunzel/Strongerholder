extends TabContainer


signal data_saved



func save_data(_tab: int = 0) -> void:
	emit_signal("data_saved")


func update_all_data() -> void:
	for tab in get_children():
		tab.update_all_data()
