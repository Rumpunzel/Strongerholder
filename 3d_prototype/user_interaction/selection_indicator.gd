class_name SelectionIndicator
extends Sprite3D


onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false


func _on_selected(status: bool) -> void:
	if visible == status:
		return
	
	visible = status
