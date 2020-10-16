class_name GameResource, "res://assets/icons/icon_resource.svg"
extends GameObject


export(Constants.Resources) var type

export var weight: float


var called_dibs_by = null


onready var _objects_layer = ServiceLocator.objects_layer




func _ready():
	add_to_group(Constants.enum_name(Constants.Resources, type))




func drop_item():
	called_dibs_by = null
	
	var pos: Vector2 = get_parent().global_position
	
	get_parent().remove_child(self)
	_objects_layer.call_deferred("add_child", self)
	
	global_position = pos
	
	_state_machine.change_to(ObjectState.IDLE)


func pick_up_item(new_inventory):
	_state_machine.change_to(ObjectState.INACTIVE)
	
	get_parent().remove_child(self)
	new_inventory.add_child(self)



func get_owner():
	var parent = get_parent()
	
	if parent and parent.owner:
		return parent.owner
	else:
		return parent
