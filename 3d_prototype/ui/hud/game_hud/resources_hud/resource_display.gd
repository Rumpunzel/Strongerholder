class_name ResourceDisplay
extends HBoxContainer

export(Resource) var _item_resource
export(Resource) var _item_stockpiled_channel
export(Resource) var _item_unstockpiled_channel

onready var _icon: TextureRect = $Icon
onready var _name: Label = $Name
onready var _amount: Label = $Panel/MarginContainer/Amount


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_item_stockpiled_channel.connect("raised", self, "_on_item_changed")
	# warning-ignore:return_value_discarded
	_item_unstockpiled_channel.connect("raised", self, "_on_item_changed")

func _ready() -> void:
	_icon.texture = _item_resource.icon
	_name.text = "%ss" % _item_resource.name

func _exit_tree() -> void:
	_item_stockpiled_channel.disconnect("raised", self, "_on_item_changed")
	_item_unstockpiled_channel.disconnect("raised", self, "_on_item_changed")


func _on_item_changed(item: ItemResource) -> void:
	if not item == _item_resource:
		return
	
	var new_amount := 0
	#TODO: refactor this out into some kind of model
	var stockpiles := get_tree().get_nodes_in_group(Stash.STOCKPILE_GROUP)
	
	for stash in stockpiles:
		var stockpile: Stash = stash
		new_amount += stockpile.count(item)
	
	_amount.text = "%d" % new_amount
