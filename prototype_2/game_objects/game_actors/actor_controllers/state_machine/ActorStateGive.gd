class_name ActorStateGive, "res://assets/icons/game_actors/states/icon_state_give.svg"
extends ActorState


var _receiver: Object
var _item: Object



func enter(parameters: Array = [ ]):
	_receiver = parameters[0]
	_item = parameters[1]
	
	_animation_cancellable = false
	
	_change_animation(GIVE)


func animation_acted(_animation: String):
	print(_item.name)
