extends Node


signal game_save_started()
signal game_save_finished()
signal game_load_started()
signal game_load_finished()


const MENU_SCENE: PackedScene = preload("res://ui/main_menu/main_menu.tscn")
const MAIN_SCENE: PackedScene = preload("res://test.tscn")

const SAVE_LOCATION: String = "user://savegame.save"

const _LOADING_TEXT: String = "Loading..."
const _FINISHED_LOADING_TEXT: String = "Press Any Key To Continue"


var _saver_loader: SaverLoader = SaverLoader.new()


onready var _background: ColorRect = $popup/background
onready var _progress_text: Label = $popup/center_container/title_divider/load_info/progress
onready var _progress_bar: ProgressBar = $popup/center_container/title_divider/load_info/progress_bar

onready var _tween: Tween = $tween




func _ready():
	set_process(false)
	
	_saver_loader.connect("finished", _progress_text, "set_text", [_FINISHED_LOADING_TEXT])
	
	$popup/center_container/title_divider/title.text = ProjectSettings.get("application/config/name")


func _process(_delta: float):
	if $popup.visible:
		_progress_bar.value = _saver_loader.progress
		
		if _progress_bar.value >= 100:
			_progress_text.text = _FINISHED_LOADING_TEXT
			_progress_bar.value = 100
			
			set_process(false)
		else:
			_progress_text.text = _LOADING_TEXT


func _unhandled_input(event: InputEvent):
	if $popup.visible and _progress_text.text == _FINISHED_LOADING_TEXT:
		if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
			get_tree().set_input_as_handled()
			
			$popup.hide()
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
	
	get_tree().change_scene_to(MAIN_SCENE)
	
	_saver_loader.load_game(save_file, get_tree())
	
	yield(_saver_loader, "finished")



func starting_new_game(new_game: bool = false):
	if new_game:
		_progress_text.text = _FINISHED_LOADING_TEXT
		_progress_bar.value = 100
	else:
		set_process(true)
	
	$popup.show()
	
	_tween.interpolate_property(_background, "color", Color.black, Color("c8000000"), 1.0, Tween.TRANS_ELASTIC)
	_tween.start()
