class_name GameResource, "res://assets/icons/icon_resource.svg"
extends GameObject


const PERSIST_PROPERTIES_2 := ["type", "how_many_can_be_carried"]


export(Constants.Resources) var type

# warning-ignore-all:unused_class_variable
export(int, 100) var how_many_can_be_carried: int = 1


onready var _objects_layer = ServiceLocator.objects_layer
onready var _quarter_master = ServiceLocator.quarter_master




func _ready():
	if _first_time:
		_first_time = false
		
		_initliase_state_machine()
	
	
	add_to_group(Constants.enum_name(Constants.Resources, type))
	
	connect("died", self, "unregister_resource")
	
	register_resource()




func drop_item(position_to_drop: Vector2):
	_state_machine.drop_item(_objects_layer, position_to_drop)


func pick_up_item(new_inventory):
	_state_machine.pick_up_item(new_inventory)


func transfer_item(new_inventory):
	_state_machine.transfer_item(new_inventory)



func appear(new_status: bool):
	visible = new_status



func register_resource():
	 _quarter_master.register_resource(self)

func unregister_resource():
	_quarter_master.unregister_resource(self)



func _initliase_state_machine():
	_state_machine = ResourceStateMachine.new()
	_state_machine.name = "state_machine"
	add_child(_state_machine)
