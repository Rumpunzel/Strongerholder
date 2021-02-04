extends TabContainer




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("tab_changed", self, "_update_data")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func update_list() -> void:
	get_current_tab_control().update_list()


func _update_data(tab: int) -> void:
	get_tab_control(tab).update_list()
