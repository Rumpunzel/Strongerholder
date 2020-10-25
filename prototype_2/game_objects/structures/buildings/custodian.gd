class_name Custodian, "res://assets/icons/structures/icon_custodian.svg"
extends ToolBelt


const PERSIST_OBJ_PROPERTIES := ["distributed_tools"]


var distributed_tools: Array = [ ]



func get_available_tool() -> Spyglass:
	for craft_tool in get_children():
		if not distributed_tools.has(craft_tool):
			distributed_tools.append(craft_tool)
			
			return craft_tool
	
	return null


func still_has_tools() -> bool:
	for craft_tool in get_children():
		if not distributed_tools.has(craft_tool):
			return true
	
	return false
