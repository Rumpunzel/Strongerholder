class_name HUD
extends CanvasLayer

export(PackedScene) var _game_hud_scene

var _game_hud: GameHUD


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.main.connect("game_started", self, "_on_game_started")

func _exit_tree() -> void:
	Events.main.disconnect("game_started", self, "_on_game_started")


func _on_game_started() -> void:
	if _game_hud:
		remove_child(_game_hud)
		_game_hud.queue_free()
	
	_game_hud = _game_hud_scene.instance()
	add_child(_game_hud)
