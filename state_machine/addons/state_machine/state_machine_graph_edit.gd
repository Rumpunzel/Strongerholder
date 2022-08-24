extends GraphEdit
tool

var _state_graph_node_scene := preload("res://addons/state_machine/state_graph_node.tscn")

onready var _popup_menu: PopupMenu = $PopupMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event: InputEventMouseButton = event
		if mouse_button_event.button_index == BUTTON_RIGHT:
			get_tree().set_input_as_handled()
			_popup_menu.set_global_position(get_global_mouse_position())
			_popup_menu.popup()


func _on_popup_menu_index_pressed(index: int) -> void:
	match index:
		0:
			var new_state_graph_node: GraphNode = _state_graph_node_scene.instance()
			add_child(new_state_graph_node, true)
			new_state_graph_node.position = get_global_mouse_position()
