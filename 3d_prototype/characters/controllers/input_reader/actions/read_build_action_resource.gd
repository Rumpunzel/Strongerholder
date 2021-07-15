class_name ReadBuildActionResource
extends StateActionResource

func _create_action() -> StateAction:
	return ReadBuildAction.new()


class ReadBuildAction extends StateAction:
	func on_update(_delta: float) -> void:
		if Input.is_action_just_released("open_build_menu"):
			Events.hud.emit_signal("building_hud_toggled")
