class_name ActorStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends ActorState


export(NodePath) var _puppet_master_node


var _item: GameResource


onready var _puppet_master: PuppetMaster = get_node(_puppet_master_node)



func enter(parameters: Array = [ ]):
	_item = parameters[0]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)



func animation_acted(_animation: String):
	if not _item:
		return
	
	_puppet_master.drop_item(_item)
	
	print(_item.name)
