class_name ResourceDisplay
extends HBoxContainer

enum CommandType { PUSH = 1, POP }

export(Resource) var _item_resource
export(Resource) var _item_stockpiled_channel
export(Resource) var _item_unstockpiled_channel

export var _max_animation_time := 0.5

onready var _icon: TextureRect = $Icon
onready var _name: Label = $Name
onready var _amount_label: Label = $Panel/MarginContainer/Amount
onready var _tick_timer: Timer = Timer.new()

var _amount := 0 setget _set_amount
var _command_queue := [ ]


func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	_item_stockpiled_channel.connect("raised", self, "_on_item_stockpiled")
	# warning-ignore:return_value_discarded
	_item_unstockpiled_channel.connect("raised", self, "_on_item_unstockpiled")

func _ready() -> void:
	_icon.texture = _item_resource.icon
	_name.text = "%ss" % _item_resource.name
	
	# warning-ignore:return_value_discarded
	_tick_timer.connect("timeout", self, "_parse_command")
	add_child(_tick_timer)

func _exit_tree() -> void:
	_item_stockpiled_channel.disconnect("raised", self, "_on_item_stockpiled")
	_item_unstockpiled_channel.disconnect("raised", self, "_on_item_unstockpiled")


func _on_item_stockpiled(item: ItemResource) -> void:
	if not item == _item_resource:
		return
	
	#TODO: refactor this out into some kind of model
	var stockpiles := get_tree().get_nodes_in_group(Stash.STOCKPILE_GROUP)
	
	var new_amount := 0
	for stash in stockpiles:
		var stockpile: Stash = stash
		new_amount += stockpile.count(item)
	
	for _i in range(new_amount - _amount):
		_command_queue.push_back(CommandType.PUSH)
		_tick_timer.start(_max_animation_time / float(_command_queue.size()))

func _on_item_unstockpiled(item: ItemResource) -> void:
	if not item == _item_resource:
		return
	
	#TODO: refactor this out into some kind of model
	var stockpiles := get_tree().get_nodes_in_group(Stash.STOCKPILE_GROUP)
	
	var new_amount := 0
	for stash in stockpiles:
		var stockpile: Stash = stash
		new_amount += stockpile.count(item)
	
	for _i in range(_amount - new_amount):
		_command_queue.push_back(CommandType.POP)
		_tick_timer.start(_max_animation_time / float(_command_queue.size()))


func _parse_command() -> void:
	var command_type: int = _command_queue.pop_front()
	if _command_queue.empty():
		_tick_timer.stop()
	match command_type:
		CommandType.PUSH:
			_set_amount(_amount + 1)
		CommandType.POP:
			_set_amount(_amount - 1)
		_:
			assert(false)

func _set_amount(new_amount: int) -> void:
	_amount = new_amount
	_amount_label.text = "%d" % _amount
