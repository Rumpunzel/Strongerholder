class_name AnimationStateMachine
extends AnimationTree


const ANIMATIONS: Array = ["idle", "run", "attack", "give", "idle_give"]


var blend_positions: Vector2 setget set_blend_positions


onready var _state_machine: AnimationNodeStateMachinePlayback = get("parameters/playback")




func _init():
	set_blend_positions(Vector2(0, 1))
	active = true




func travel(new_animation: String):
	_state_machine.travel(new_animation)



func set_blend_positions(new_direction: Vector2):
	blend_positions = new_direction
	
	for animation in ANIMATIONS:
		set("parameters/%s/blend_position" % [animation], blend_positions)
