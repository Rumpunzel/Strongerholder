extends GraphNode
tool

onready var _deletion_dialog: ConfirmationDialog = $DeletionDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_resize_request(new_minsize: Vector2) -> void:
	rect_size = new_minsize

func _on_close_request() -> void:
	_deletion_dialog.popup_centered()


func _on_deletion_confirmed() -> void:
	get_parent().remove_child(self)
	queue_free()
