class_name GUI
extends CanvasLayer

func _on_game_hud_showed(layer: GUILayerBase) -> void:
	_show_exlusively(layer)

func _on_main_menu_showed(layer: GUILayerBase) -> void:
	_show_exlusively(layer)


func _show_exlusively(layer: GUILayerBase) -> void:
	for child in get_children():
		if not child == layer:
			child.hide_menu()
