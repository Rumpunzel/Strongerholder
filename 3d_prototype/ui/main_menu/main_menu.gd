class_name MainMenu
extends GUILayerBase


const QUIT_GAME_QUESTION: String = "Quit The Game?"


export var _animation_distance: float = 200.0

export(Resource) var _game_paused_channel
export(Resource) var _game_continued_channel

export(Resource) var _game_pause_requested_channel
export(Resource) var _game_continue_requested_channel

export(Resource) var _game_save_started_channel
export(Resource) var _game_load_started_channel

export(Resource) var _game_quit_channel


onready var _menu_container: Control = $MenuContainer



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_game_paused_channel.connect("raised", self, "_on_game_paused")
	# warning-ignore:return_value_discarded
	_game_continued_channel.connect("raised", self, "_on_game_continued")

func _exit_tree() -> void:
	_game_paused_channel.disconnect("raised", self, "_on_game_paused")
	_game_continued_channel.disconnect("raised", self, "_on_game_continued")


func _ready() -> void:
	_game_pause_requested_channel.raise()



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("pause_game"):
		if visible:
			_on_start_pressed()
		else:
			_game_pause_requested_channel.raise()
		
		get_tree().set_input_as_handled()


func _on_game_paused() -> void:
	show_menu()

func _on_game_continued() -> void:
	hide_menu()


func _on_start_pressed() -> void:
	_game_continue_requested_channel.raise()

func _on_restart_pressed():
	_game_load_started_channel.raise(true)

func _on_save_pressed():
	_game_save_started_channel.raise()

func _on_load_pressed():
	_game_load_started_channel.raise(false)

func _on_quit_pressed() -> void:
	var dialog: ConfirmationDialog = ConfirmationDialog.new()
	
	dialog.dialog_text = QUIT_GAME_QUESTION
	dialog.window_title = ""
	
	# warning-ignore:return_value_discarded
	dialog.get_cancel().connect("pressed", dialog, "queue_free")
	# warning-ignore:return_value_discarded
	dialog.connect("confirmed", _game_quit_channel, "raise")
	
	add_child(dialog)
	dialog.popup_centered()


func _show_menu() -> void:
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_menu_container, "rect_position:x", rect_position.x - _animation_distance, rect_position.x, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	._show_menu()


func _hide_menu() -> void:
	var previous_position := _menu_container.rect_position.x
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_menu_container, "rect_position:x", previous_position, previous_position - _animation_distance, _animation_duration, Tween.TRANS_QUAD, Tween.EASE_IN)
	._hide_menu()
	yield(_tween, "tween_all_completed")
	_menu_container.rect_position.x = previous_position
