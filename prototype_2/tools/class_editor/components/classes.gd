extends TabContainer


signal data_saved




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("tab_changed", self, "_update_data")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func save_data() -> void:
	emit_signal("data_saved")



func _update_data(tab: int) -> void:
	get_tab_control(tab).update_list()
