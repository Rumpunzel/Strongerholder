class_name MainMenu
extends GUILayerBase

const QUIT_GAME_QUESTION: String = "Quit The Game?"

export var _animation_distance: float = 200.0

onready var _menu_container: Control = $VBoxContainer/MenuContainer


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.main.connect("game_load_finished", self, "_on_game_load_finished")
	# warning-ignore:return_value_discarded
	Events.menu.connect("main_menu_requested", self, "_on_main_menu_requested")

func _exit_tree() -> void:
	Events.main.disconnect("game_load_finished", self, "_on_game_load_finished")
	Events.menu.disconnect("main_menu_requested", self, "_on_main_menu_requested")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("pause_game"):
		get_tree().set_input_as_handled()
		if visible:
			_on_start_pressed()
		else:
			show_menu()


func _on_main_menu_requested() -> void:
	show_menu()

func _on_start_pressed() -> void:
	hide_menu()
	Events.main.emit_signal("game_unpaused")

func _on_restart_pressed():
	Events.main.emit_signal("game_load_started", true)

func _on_save_pressed():
	Events.main.emit_signal("game_save_started")

func _on_load_pressed():
	Events.main.emit_signal("game_load_started")

func _on_quit_pressed() -> void:
	var dialog: ConfirmationDialog = ConfirmationDialog.new()
	
	dialog.dialog_text = QUIT_GAME_QUESTION
	dialog.window_title = ""
	
	# warning-ignore:return_value_discarded
	dialog.get_cancel().connect("pressed", dialog, "queue_free")
	# warning-ignore:return_value_discarded
	dialog.connect("confirmed", Events.main, "emit_signal", [ "game_quit" ])
	
	add_child(dialog)
	dialog.popup_centered()


func _on_game_load_finished() -> void:
	hide_menu()
	Events.main.emit_signal("game_unpaused")


func _show_menu() -> void:
	Events.main.emit_signal("game_paused")
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_menu_container, "rect_position:x", rect_position.x - _animation_distance, rect_position.x, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	._show_menu()


func _hide_menu() -> void:
	Events.main.emit_signal("game_unpaused")
	var previous_position := _menu_container.rect_position.x
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_menu_container, "rect_position:x", previous_position, previous_position - _animation_distance, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_IN)
	._hide_menu()
	yield(_tween, "tween_all_completed")
	_menu_container.rect_position.x = previous_position
