class_name ClickBox
extends Area

signal selected(status)

export(Resource) var _node_selected_channel


func _input_event(_camera: Object, event: InputEvent, _click_position: Vector3, _click_normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event: InputEventMouseButton = event
		match mouse_button_event.button_index:
			BUTTON_LEFT:
				if not mouse_button_event.pressed:
					emit_signal("selected", true)
					_node_selected_channel.raise(owner)
					get_tree().set_input_as_handled()
			
			BUTTON_RIGHT:
				emit_signal("selected", false)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event: InputEventMouseButton = event
		if not mouse_button_event.pressed:
			emit_signal("selected", false)
