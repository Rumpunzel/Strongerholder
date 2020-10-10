class_name GameActor, "res://assets/icons/game_actors/icon_game_actor.svg"
extends KinematicBody2D


signal moved(direction)
signal entered_segment(ring_vector)

signal activate
signal deactivate
signal died


export(NodePath) var _puppet_master_node
export(NodePath) var _animation_tree_node

export var move_speed: float = 64.0
export var sprint_modifier: float = 2.0


var velocity: Vector2 = Vector2() setget set_velocity
var sprinting: bool = false setget set_sprinting


# Multiplicative modifer to the movement speed
#	is equal to 1.0 if the gameactor is walking normal
var _movement_modifier: float = 1.0


onready var _puppet_master = get_node(_puppet_master_node)
onready var _animation_tree: AnimationStateMachine = get_node(_animation_tree_node)




func _setup(player_controlled: bool = false):
	_puppet_master.set_player_controlled(player_controlled)
	activate_object()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	
	emit_signal("moved", velocity)




func activate_object():
	emit_signal("activate")

func deactivate_object():
	emit_signal("deactivate")


func move_to(direction: Vector2, is_sprinting: bool = false):
	set_sprinting(is_sprinting)
	set_velocity(direction)
	_parse_state(direction)


func object_died():
	emit_signal("died")





func _parse_state(direction: Vector2):
	if direction.length() > 0:
		_animation_tree.blend_positions = direction
		_animation_tree.travel("run", false)
	elif _animation_tree.get_current_state() == "run":
		_animation_tree.travel("idle", false)




func set_velocity(new_velocity: Vector2):
	velocity = new_velocity.normalized() * move_speed * _movement_modifier


func set_sprinting(new_status: bool):
	sprinting = new_status
	_movement_modifier = sprint_modifier if sprinting else 1.0
