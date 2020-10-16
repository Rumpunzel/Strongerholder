class_name ActorStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends ActorState


export(NodePath) var _inventory_node


var _item: Node2D


onready var _inventory: Inventory = get_node(_inventory_node)



func enter(parameters: Array = [ ]):
	_item = parameters[0]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String):
	if not _item:
		return
	
	_inventory.drop_item(_item)
	
	print(_item.name)
