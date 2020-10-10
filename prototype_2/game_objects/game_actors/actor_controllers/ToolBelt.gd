class_name ToolBelt, "res://assets/icons/game_actors/icon_tool_belt.svg"
extends GameAudioPlayer


func has_tool_for_this(other_hit_box: ObjectHitBox):
	for craft_tool in get_children():
		if craft_tool.check_for_interaction(other_hit_box):
			return craft_tool
	
	return null


func valid_targets() -> Array:
	var has_tools_for: Array = [ ]
	
	for craft_tool in get_children():
		has_tools_for += craft_tool.used_for
	
	return has_tools_for
