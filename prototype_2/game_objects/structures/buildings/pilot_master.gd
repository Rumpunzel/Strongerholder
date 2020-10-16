class_name PilotMaster, "res://assets/icons/structures/icon_pilot_master.svg"
extends Area2D


onready var _inventory: Inventory = $inventory




# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "pick_up_item")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func pick_up_item(item: GameResource):
	_inventory.pick_up_item(item)


func drop_all_items():
	_inventory.drop_all_items()
