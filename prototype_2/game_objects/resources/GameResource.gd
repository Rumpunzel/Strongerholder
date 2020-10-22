class_name GameResource, "res://assets/icons/icon_resource.svg"
extends GameObject


export(Constants.Resources) var type

# warning-ignore-all:unused_class_variable
export var weight: float


var _current_registration: ResourceSightings.ResourceProfile = null


onready var _objects_layer = ServiceLocator.objects_layer
onready var _quarter_master = ServiceLocator.quarter_master




func _ready():
	add_to_group(Constants.enum_name(Constants.Resources, type))
	
	connect("died", self, "unregister_resource")
	
	register_resource()




func drop_item(position_to_drop: Vector2):
	_state_machine.drop_item(_objects_layer, position_to_drop)


func pick_up_item(new_inventory):
	_state_machine.pick_up_item(new_inventory)



func register_resource():
	_current_registration = _quarter_master.register_resource(self, null)

func unregister_resource():
	_quarter_master.unregister_resource(_current_registration)
