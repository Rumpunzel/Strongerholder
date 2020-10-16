class_name GameResource, "res://assets/icons/icon_resource.svg"
extends GameObject


export(Constants.Resources) var type

export var weight: float


onready var _objects_layer = ServiceLocator.objects_layer




func _ready():
	add_to_group(Constants.enum_name(Constants.Resources, type))




func drop_item(position_to_drop: Vector2):
	_state_machine.drop_item(_objects_layer, position_to_drop)


func pick_up_item(new_inventory):
	_state_machine.pick_up_item(new_inventory)
