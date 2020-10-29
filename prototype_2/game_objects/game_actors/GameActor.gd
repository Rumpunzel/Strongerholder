class_name GameActor, "res://assets/icons/game_actors/icon_game_actor.svg"
extends KinematicBody2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true
const SCENE := "res://game_objects/game_actors/GameActor.tscn"

const PERSIST_PROPERTIES := ["name", "position", "player_controlled", "_first_time"]
const PERSIST_OBJ_PROPERTIES := ["_puppet_master", "_state_machine"]


const _PUPPET_MASTER_SCENE: PackedScene = preload("res://game_objects/game_actors/actor_controllers/puppet_master.tscn")


signal moved(direction)

signal died


var velocity: Vector2 = Vector2()
var player_controlled: bool = false setget set_player_controlled


var _first_time: bool = true
var _puppet_master: InputMaster
var _state_machine: ActorStateMachine


onready var _collision_shape: CollisionShape2D = $collision_shape




func _ready():
	if _first_time:
		_first_time = false
		
		_puppet_master = _PUPPET_MASTER_SCENE.instance()
		add_child(_puppet_master)
		
		_state_machine = ActorStateMachine.new()
		_state_machine.name = "state_machine"
		_state_machine._puppet_master = _puppet_master
		_state_machine.animation_tree_node = "../%s" % "animation_tree"
		add_child(_state_machine)
	
	$state_label._state_machine = _state_machine
	$job_label._puppet_master = _puppet_master


func _process(_delta: float):
	if _puppet_master and _state_machine:
		_puppet_master.process_commands(_state_machine, player_controlled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float):
	velocity = move_and_slide(velocity)
	
	if not velocity == Vector2():
		emit_signal("moved", velocity)





func damage(damage_points: float, sender) -> bool:
	return _state_machine.damage(damage_points, sender)


func die():
	emit_signal("died")


func is_active() -> bool:
	return _state_machine.is_active()


func enable_collision(new_status: bool):
	_collision_shape.set_deferred("disabled", not new_status)



func set_player_controlled(new_status: bool):
	player_controlled = new_status
