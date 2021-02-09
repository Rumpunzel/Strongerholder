class_name InfoMenu
extends TabContainer


var _currently_selected: GameObject = null




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func object_selected(new_object: GameObject) -> void:
	_currently_selected = new_object
	
	visible = true if _currently_selected else false
	
	for menu in get_children():
		menu.object_selected(new_object)
