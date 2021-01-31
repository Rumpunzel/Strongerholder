extends Node


signal game_save_started()
signal game_save_finished()
signal game_load_started()
signal game_load_finished()


const MainScene: PackedScene = preload("res://test.tscn")

const SAVE_LOCATION: String = "user://savegame.save"

const _LOADING_TEXT: String = "Loading..."
const _FINISHED_LOADING_TEXT: String = "Press Any Key To Continue"


var _saver_loader: SaverLoader = SaverLoader.new()


onready var _background: ColorRect = $Popup/Background
onready var _progress_text: Label = $Popup/CenterContainer/TitleDivider/LoadInfo/Progress
onready var _progress_bar: ProgressBar = $Popup/CenterContainer/TitleDivider/LoadInfo/ProgressBar

onready var _tween: Tween = $Tween




func _ready() -> void:
	set_process(false)
	
	_saver_loader.connect("finished", _progress_text, "set_text", [_FINISHED_LOADING_TEXT])
	
	$Popup/CenterContainer/TitleDivider/Title.text = ProjectSettings.get("application/config/name")


func _process(_delta: float) -> void:
	if $Popup.visible:
		_progress_bar.value = _saver_loader.progress
		
		if _progress_bar.value >= 100:
			_progress_text.text = _FINISHED_LOADING_TEXT
			_progress_bar.value = 100
			
			set_process(false)
		else:
			_progress_text.text = _LOADING_TEXT


func _input(event: InputEvent) -> void:
	if $Popup.visible:
		get_tree().set_input_as_handled()
		
		if _progress_text.text == _FINISHED_LOADING_TEXT and not event.is_pressed() and (event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton):
			$Popup.hide()
			emit_signal("game_load_finished")
			get_tree().paused = false




func save_game(path: String) -> void:
	var save_file := File.new()
	
	save_file.open(path, File.WRITE)
	emit_signal("game_save_started")
	
	_saver_loader.save_game(save_file, get_tree())
	
	yield(_saver_loader, "finished")
	
	emit_signal("game_save_finished")


func load_game(path: String) -> void:
	starting_new_game()
	
	var save_file := File.new()
	
	save_file.open(path, File.READ)
	emit_signal("game_load_started")
	
	get_tree().change_scene_to(MainScene)
	
	_saver_loader.load_game(save_file, get_tree())
	
	yield(_saver_loader, "finished")



func starting_new_game(new_game: bool = false) -> void:
	if new_game:
		_progress_text.text = _FINISHED_LOADING_TEXT
		_progress_bar.value = 100
	else:
		set_process(true)
	
	$Popup.show()
	
	_tween.interpolate_property(_background, "color", Color.black, Color("c8000000"), 1.0, Tween.TRANS_ELASTIC)
	_tween.start()
