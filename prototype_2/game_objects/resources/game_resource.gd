class_name GameResource, "res://class_icons/game_objects/resources/icon_resource.svg"
extends GameObject


const PERSIST_PROPERTIES_2 := ["type", "can_carry"]

# warning-ignore-all:unused_class_variable
var can_carry: int = 1


onready var _objects_layer = ServiceLocator.objects_layer
onready var _quarter_master = ServiceLocator.quarter_master




func _ready() -> void:
	if _first_time:
		_first_time = false
		
		_initialise_state_machine()
	
	connect("died", self, "unregister_resource")
	
	register_resource()




func drop_item(position_to_drop: Vector2) -> void:
	_state_machine.drop_item(_objects_layer, position_to_drop)


func pick_up_item(new_inventory) -> void:
	_state_machine.pick_up_item(new_inventory)


func transfer_item(new_inventory) -> void:
	_state_machine.transfer_item(new_inventory)



func appear(new_status: bool) -> void:
	visible = new_status



func register_resource() -> void:
	 _quarter_master.register_resource(self)

func unregister_resource() -> void:
	_quarter_master.unregister_resource(self)



func _initialise_state_machine() -> void:
	_state_machine = ResourceStateMachine.new()
	_state_machine.name = "state_machine"
	_state_machine.game_object = self
	
	add_child(_state_machine)
