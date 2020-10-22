class_name Custodian, "res://assets/icons/structures/icon_custodian.svg"
extends ToolBelt


var distributed_tools: Array = [ ]



func get_available_tool() -> Spyglass:
	for craft_tool in get_children():
		if not distributed_tools.has(craft_tool):
			distributed_tools.append(craft_tool)
			
			return craft_tool
	
	return null
