class_name PilotMaster, "res://assets/icons/structures/icon_pilot_master.svg"
extends InputMaster


const PERSIST_OBJ_PROPERTIES_3 := ["game_object", "_desired_items"]


# warning-ignore-all:unused_class_variable
var game_object: Node2D = null

var _desired_items: Array = [ ]


onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", self, "take_item")
	
	register_resource()




func take_item(item_to_take: Node2D) -> void:
	_desired_items.append(item_to_take)


func register_resource() -> void:
	_quarter_master.register_resource(game_object)

func unregister_resource() -> void:
	_quarter_master.unregister_resource(game_object)



func _get_input(_player_controlled: bool) -> Array:
	var commands: Array = [ ]
	
	while not _desired_items.empty():
		var item: Node2D = _desired_items.pop_front()
		
		if in_range(item):
			commands.append(TakeCommand.new(item))
	
	return commands
