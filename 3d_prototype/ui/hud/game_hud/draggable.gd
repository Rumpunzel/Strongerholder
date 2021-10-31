class_name Draggable
extends Control


var _being_dragged := false
var _offset := Vector2.ZERO

onready var _draggable: Control = owner



func _ready() -> void:
	assert(_draggable is Control)
	_draggable.connect("gui_input", self, "_on_gui_input")


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == BUTTON_LEFT:
			_being_dragged = mouse_event.pressed
			
			if mouse_event.pressed:
				_offset = get_global_mouse_position() - _draggable.rect_position
			
			get_tree().set_input_as_handled()


func _process(_delta: float):
	if _being_dragged:
		_draggable.rect_position = get_global_mouse_position() - _offset
