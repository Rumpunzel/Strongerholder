class_name PilotMaster, "res://assets/icons/structures/icon_pilot_master.svg"
extends Area2D


var _current_registration: ResourceSightings.ResourceProfile = null


onready var _inventory: Inventory = $inventory

onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "pick_up_item")
	
	register_resource()




func _physics_process(_delta):
	# TODO: HACK WORKAROUND UNTIL GODOT FIXES AREA'S RECOGNIZING A BODY ACTIVATING INSIDE IT
	position = Vector2()



func pick_up_item(item: GameResource):
	print("I FOUND THIS HERE: %s" % [item.name])
	_inventory.pick_up_item(item)


func drop_item(item: GameResource, position_to_drop: Vector2 = global_position):
	_inventory.drop_item(item, position_to_drop)

func drop_all_items(position_to_drop: Vector2 = global_position):
	_inventory.drop_all_items(position_to_drop)


func register_resource(maximum_workers = 1):
	_current_registration = _quarter_master.register_resource(owner, _inventory, maximum_workers)
