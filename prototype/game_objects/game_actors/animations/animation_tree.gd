class_name AnimationStateMachine
extends AnimationTree


var blend_positions: Vector2 setget set_blend_positions, get_blend_positions

var next_animation: String = "idle"


onready var state_machine: AnimationNodeStateMachinePlayback = get("parameters/playback")




func _init():
	set_blend_positions(Vector2(0, 1))
	active = true


func _process(_delta):
	if not is_idle_animation(next_animation):
		next_animation = "idle"




func travel(new_animation: String):
	if is_idle_animation(next_animation):
		next_animation = new_animation
		
		state_machine.travel(new_animation)


func is_idle() -> bool:
	return is_idle_animation(next_animation) and is_idle_animation(get_current_state())


func is_idle_animation(animation: String = next_animation) -> bool:
	return animation.begins_with("idle") or animation == "run"



func set_blend_positions(new_direction: Vector2):
	blend_positions = new_direction
	
	set("parameters/idle/blend_position", blend_positions)
	set("parameters/run/blend_position", blend_positions)
	set("parameters/attack/blend_position", blend_positions)
	set("parameters/give/blend_position", blend_positions)
	set("parameters/idle_give/blend_position", blend_positions)



func get_blend_positions() -> Vector2:
	return blend_positions

func get_current_state() -> String:
	return state_machine.get_current_node()
