extends MenuButton


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_popup().add_item("Delete")
	get_popup().connect("id_pressed", self, "_are_you_sure")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _are_you_sure(_id: int):
	var dialog: ConfirmationDialog = ConfirmationDialog.new()
	
	dialog.dialog_text = "Delete this Class?"
	dialog.window_title = ""
	
	dialog.get_cancel().connect("pressed", dialog, "queue_free")
	dialog.connect("confirmed", owner, "delete")
	
	add_child(dialog)
	dialog.popup_centered()
