class_name LoadingGUI
extends Popup


signal game_load_finished


const LOADING_TEXT: String = "Loading..."
const FINISHED_LOADING_TEXT: String = "Press Any Key To Continue"


onready var _background: ColorRect = $Background
onready var _progress_text: Label = $CenterContainer/TitleDivider/LoadInfo/Progress
onready var _progress_bar: ProgressBar = $CenterContainer/TitleDivider/LoadInfo/ProgressBar
onready var _title: Label = $CenterContainer/TitleDivider/Title

onready var _tween: Tween = $Tween




func _ready() -> void:
	set_process(false)
	
	SaverLoader.connect("finished", _progress_text, "set_text", [ FINISHED_LOADING_TEXT ])
	
	_title.text = ProjectSettings.get("application/config/name")


func _process(_delta: float) -> void:
	if visible:
		_progress_bar.value = SaverLoader.progress
		
		if _progress_bar.value >= 100:
			_progress_text.text = FINISHED_LOADING_TEXT
			_progress_bar.value = 100
			
			set_process(false)
		else:
			_progress_text.text = LOADING_TEXT


func _gui_input(event: InputEvent) -> void:
	_check_input(event)


func _unhandled_input(event: InputEvent) -> void:
	if visible:
		get_tree().set_input_as_handled()
		_check_input(event)




func loading_game(new_game: bool = false) -> void:
	if new_game:
		_progress_text.text = FINISHED_LOADING_TEXT
		_progress_bar.value = 100
	else:
		set_process(true)
	
	show()
	
	_tween.interpolate_property(_background, "color", Color.black, Color("c8000000"), 1.0, Tween.TRANS_ELASTIC)
	_tween.start()


func _check_input(event: InputEvent) -> void:
	if _progress_text.text == FINISHED_LOADING_TEXT and _any_key_released(event):
		hide()
		emit_signal("game_load_finished")
		get_tree().paused = false


func _any_key_released(event: InputEvent) -> bool:
	return (event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton) and not event.is_pressed()
