class_name GameResource, "res://assets/icons/icon_resource.svg"
extends GameObject


const REQUEST = "Request_"

const RESOURCES: Array = [
	"Wood",
	"WoodPlanks",
	"Stone",
]


export var weight:float


var called_dibs_by = null


onready var resource_layer = get_tree().current_scene




func drop_item():
	var position: RingVector = get_parent().owner.ring_vector
	
	activate_object()
	called_dibs_by = null
	get_parent().remove_child(self)
	resource_layer.add_child(self)
	set_ring_vector(position)


func pick_up_item(new_inventory):
	deactivate_object()
	get_parent().remove_child(self)
	new_inventory.add_child(self)
	set_ring_vector(new_inventory.owner.ring_vector)



func get_owner():
	var parent = get_parent()
	
	if parent and parent.owner:
		return parent.owner
	else:
		return parent
