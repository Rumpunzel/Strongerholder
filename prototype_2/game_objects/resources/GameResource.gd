class_name GameResource, "res://assets/icons/icon_resource.svg"
extends GameObject


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true
const SCENE := "res://game_objects/resources/GameResource.tscn"

const PERSIST_PROPERTIES := ["name", "position", "_maximum_operators", "type", "how_many_can_be_carried"]
const PERSIST_OBJ_PROPERTIES := ["_assigned_workers"]


export(Constants.Resources) var type

# warning-ignore-all:unused_class_variable
export(int, 10) var how_many_can_be_carried: int = 1


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



func appear(new_status: bool):
	visible = new_status



func register_resource():
	 _quarter_master.register_resource(self)

func unregister_resource():
	_quarter_master.unregister_resource(self)
