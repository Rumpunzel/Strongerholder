extends MarginContainer


onready var add_button: Button = $TitleDivider/TopContainer/Button
onready var class_list: ClassGrid = $TitleDivider/ScrollContainer/ClassGrid




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_button.connect("pressed", class_list, "add_class")
	#class_list.connect("item_edited", self, "save_classes")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




func save_classes():
	GameClassFactory.create_file(class_list.get_class_interfaces())
