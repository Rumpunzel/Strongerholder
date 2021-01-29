class_name PilotMaster, "res://assets/icons/structures/icon_pilot_master.svg"
extends InputMaster


const PERSIST_OBJ_PROPERTIES_3 := ["_desired_items"]


var _desired_items: Array = [ ]


onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("died", self, "unregister_resource")
	connect("body_entered", self, "take_item")
	
	register_resource()




func take_item(item_to_take: Node2D):
	_desired_items.append(item_to_take)


func register_resource():
	_quarter_master.register_resource(get_parent())

func unregister_resource():
	_quarter_master.unregister_resource(get_parent())



func _get_input(_player_controlled: bool) -> Array:
	var commands: Array = [ ]
	
	while not _desired_items.empty():
		var item: Node2D = _desired_items.pop_front()
		
		if in_range(item):
			commands.append(TakeCommand.new(item))
	
	return commands
