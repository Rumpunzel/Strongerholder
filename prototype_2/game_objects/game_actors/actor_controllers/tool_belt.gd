class_name ToolBelt, "res://assets/icons/game_actors/icon_tool_belt.svg"
extends Node2D



func get_tools() -> Array:
	return get_children()



func get_valid_targets() -> Array:
	var has_tools_for: Array = [ ]
	
	for craft_tool in get_children():
		for target in craft_tool.used_for:
			has_tools_for.append(Constants.enum_name(Constants.Resources, target))
	
	return has_tools_for
