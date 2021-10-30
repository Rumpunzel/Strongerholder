class_name InspectionHUD
extends PopupPanel

export(Resource) var _node_selected_channel

var _selected_node: Node


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_node_selected_channel.connect("raised", self, "_on_node_selected")

func _exit_tree() -> void:
	_node_selected_channel.disconnect("raised", self, "_on_node_selected")


func _on_node_selected(node: Node) -> void:
	if _selected_node == node:
		return
	
	_selected_node = node
	print(_selected_node.name)
