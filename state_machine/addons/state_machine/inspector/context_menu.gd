extends PopupMenu
tool

signal state_requested()
signal condition_requested()

enum Options {
	ADD_STATE,
	ADD_CONDITION,
}

func _enter_tree() -> void:
	clear()
	add_icon_item(preload("res://addons/state_machine/icons/icon_cog_32.png"), "Add State", Options.ADD_STATE)
	add_icon_item(preload("res://addons/state_machine/icons/icon_choice_32.png"), "Add Condition", Options.ADD_CONDITION)


func _on_id_pressed(id: int) -> void:
	match id:
		Options.ADD_STATE:
			emit_signal("state_requested")
		Options.ADD_CONDITION:
			emit_signal("condition_requested")
