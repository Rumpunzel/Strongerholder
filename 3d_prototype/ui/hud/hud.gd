class_name HUD
extends CanvasLayer

export(PackedScene) var _game_hud_scene


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	Events.main.connect("game_started", self, "_on_game_started")

func _exit_tree() -> void:
	Events.main.disconnect("game_started", self, "_on_game_started")


func _on_game_started() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	var game_hud: GameHUD = _game_hud_scene.instance()
	add_child(game_hud)
