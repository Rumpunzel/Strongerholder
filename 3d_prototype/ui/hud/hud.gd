class_name HUD
extends CanvasLayer

export(PackedScene) var _game_hud_scene

export(Resource) var _game_started_channel


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_game_started_channel.connect("raised", self, "_on_game_started")

func _exit_tree() -> void:
	_game_started_channel.disconnect("raised", self, "_on_game_started")


func _on_game_started() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	var game_hud: GameHUD = _game_hud_scene.instance()
	add_child(game_hud)
