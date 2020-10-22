class_name PilotMaster, "res://assets/icons/structures/icon_pilot_master.svg"
extends InputMaster


var _current_registration: ResourceSightings.ResourceProfile = null

var _desired_items: Array = [ ]


onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




# Called when the node enters the scene tree for the first time.
func _ready():
	owner.connect("died", self, "unregister_resource")
	connect("body_entered", self, "take_item")
	
	register_resource()




func take_item(item_to_take: Node2D):
	_desired_items.append(item_to_take)


func register_resource():
	_current_registration = _quarter_master.register_resource(owner, self)

func unregister_resource():
	_quarter_master.unregister_resource(_current_registration)


func check_area_for_item(_item: GameResource):
	# TODO: HACK WORKAROUND UNTIL GODOT FIXES AREA'S RECOGNIZING A BODY ACTIVATING INSIDE IT
	position = Vector2()



func _get_input() -> Array:
	var commands: Array = [ ]
	
	while not _desired_items.empty():
		var item: Node2D = _desired_items.pop_front()
		
		if _in_range(item):
			commands.append(TakeCommand.new(item))
	
	return commands
