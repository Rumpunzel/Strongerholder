class_name AnimationStateMachine
extends AnimationTree


# warning-ignore:unused_signal
signal acted(anim_name)
# warning-ignore:unused_signal
signal action_finished(anim_name)
# warning-ignore:unused_signal
signal stepped(anim_name)
# warning-ignore:unused_signal
signal animation_finished(anim_name)


const ANIMATIONS: Array = ["idle", "run", "attack", "give"]


var blend_positions: Vector2 setget set_blend_positions


onready var _animation_player: AnimationPlayer = get_node(anim_player)
onready var _state_machine: AnimationNodeStateMachinePlayback = get("parameters/playback")




func _init() -> void:
	set_blend_positions(Vector2(0, 1))
	active = true


func _ready() -> void:
	_animation_player.connect("acted", self, "_transfer_signal", ["acted"])
	_animation_player.connect("stepped", self, "_transfer_signal", ["stepped"])
	
	_animation_player.connect("action_finished", self, "_transfer_signal", ["action_finished"])
	_animation_player.connect("animation_finished", self, "_transfer_signal", ["animation_finished"])




func travel(new_animation: String) -> void:
	_state_machine.travel(new_animation)



func set_blend_positions(new_direction: Vector2) -> void:
	blend_positions = new_direction
	
	for animation in ANIMATIONS:
		set("parameters/%s/blend_position" % [animation], blend_positions)



func get_current_animation() -> String:
	return _state_machine.get_current_node()



func _transfer_signal(signal_name: String) -> void:
	emit_signal(signal_name, _state_machine.get_current_node())
