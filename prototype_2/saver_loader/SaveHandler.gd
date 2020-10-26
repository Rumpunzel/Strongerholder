extends Node


signal game_save_started()
signal game_save_finished()
signal game_load_started()
signal game_load_finished()


var _saver_loader: SaverLoader = SaverLoader.new()


onready var _background: ColorRect = $popup/color_rect
onready var _progress_text: Label = $popup/center_container/load_info/progress
onready var _progress_bar: ProgressBar = $popup/center_container/load_info/progress_bar

onready var _tween: Tween = $tween




func _ready():
	_saver_loader.connect("finished", _progress_text, "set_text", ["Press Any Key To Continue"])




func _unhandled_input(event: InputEvent):
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
		if $popup.visible:
			$popup.hide()
			emit_signal("game_load_finished")
			get_tree().paused = false
			
			_background.color = Color.black
			_progress_text.text = "Loading..."
			_progress_bar.value = 0




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
	
	get_tree().change_scene_to(load("res://test.tscn"))
	
	_saver_loader.load_game(save_file, get_tree())
	
	yield(_saver_loader, "finished")
	
	_progress_text.text = "Press Any Key To Continue"
	_progress_bar.value = 100



func starting_new_game(new_game: bool = false):
	if new_game:
		_progress_text.text = "Press Any Key To Continue"
		_progress_bar.value = 100
	
	$popup.show()
	
	_tween.interpolate_property(_background, "color", Color.black, Color("c8000000"), 1.0, Tween.TRANS_ELASTIC)
	_tween.start()
