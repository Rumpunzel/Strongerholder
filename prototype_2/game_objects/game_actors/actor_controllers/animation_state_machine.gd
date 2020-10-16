class_name AnimationStateMachine
extends AnimationTree


signal acted(anim_name)
signal action_finished(anim_name)
signal stepped(anim_name)
signal animation_finished(anim_name)


const ANIMATIONS: Array = ["idle", "run", "attack", "give"]


var blend_positions: Vector2 setget set_blend_positions


onready var _animation_player: AnimationPlayer = get_node(anim_player)
onready var _state_machine: AnimationNodeStateMachinePlayback = get("parameters/playback")




func _init():
	set_blend_positions(Vector2(0, 1))
	active = true


func _ready():
	_animation_player.connect("acted", self, "_transfer_signal", ["acted"])
	_animation_player.connect("stepped", self, "_transfer_signal", ["stepped"])
	
	_animation_player.connect("action_finished", self, "_transfer_signal", ["action_finished"])
	_animation_player.connect("animation_finished", self, "_transfer_signal", ["animation_finished"])




func travel(new_animation: String):
	_state_machine.travel(new_animation)



func set_blend_positions(new_direction: Vector2):
	blend_positions = new_direction
	
	for animation in ANIMATIONS:
		set("parameters/%s/blend_position" % [animation], blend_positions)



func _transfer_signal(signal_name: String):
	emit_signal(signal_name, _state_machine.get_current_node())
