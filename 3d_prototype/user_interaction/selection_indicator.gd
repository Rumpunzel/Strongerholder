class_name SelectionIndicator
extends Sprite3D


func _ready() -> void:
	visible = false


func _on_selected(status: bool) -> void:
	if visible == status:
		return
	
	visible = status
