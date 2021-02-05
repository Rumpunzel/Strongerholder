extends MarginContainer


onready var add_button: Button = $TitleDivider/TopContainer/Button
onready var class_grid: ClassGrid = $TitleDivider/ScrollContainer/ClassGrid




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_button.connect("pressed", class_grid, "add_class")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func update_list():
	class_grid.update_list()


func get_class_interfaces() -> Dictionary:
	return class_grid.get_class_interfaces()
