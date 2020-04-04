extends CanvasLayer
class_name GUI


export(PackedScene) var build_menu


var current_menu:GUIMenu = null
var focus_target = null



func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		hide(focus_target)
		get_tree().set_input_as_handled()


func show_build_menu(build_point:BuildPoint):
	if not build_point == focus_target:
		hide(focus_target)
		
		focus_target = build_point
		
		current_menu = build_menu.instance()
		current_menu.focus_target = focus_target
		add_child(current_menu)


func hide(trigger):
	if current_menu and trigger == focus_target:
		current_menu.hide()
		current_menu = null
		focus_target = null
