class_name Custodian, "res://assets/icons/structures/icon_custodian.svg"
extends ToolBelt


onready var owned_tools: Array = get_contents()




# Called when the node enters the scene tree for the first time.
func _ready():
	connect("received_item", self, "_add_to_owned_tools")




func _add_to_owned_tools(new_tool: Spyglass):
	owned_tools.append(new_tool)
