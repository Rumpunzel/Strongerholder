class_name GameResource, "res://assets/icons/icon_resource.svg"
extends GameObject


export var weight: float


var called_dibs_by = null


onready var resource_layer = get_tree().current_scene.get_node("y_sort")




func drop_item():
	activate_object()
	called_dibs_by = null
	
	var pos = get_parent().global_position
	
	get_parent().remove_child(self)
	resource_layer.add_child(self)
	
	global_position = pos


func pick_up_item(new_inventory):
	deactivate_object()
	get_parent().remove_child(self)
	new_inventory.add_child(self)



func get_owner():
	var parent = get_parent()
	
	if parent and parent.owner:
		return parent.owner
	else:
		return parent
