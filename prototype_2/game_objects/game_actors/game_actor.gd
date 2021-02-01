class_name GameActor, "res://class_icons/game_objects/game_actors/icon_game_actor.svg"
extends KinematicBody2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true
const SCENE := "res://game_objects/game_actors/game_actor.tscn"

const PERSIST_PROPERTIES := ["name", "position", "player_controlled", "_first_time"]
const PERSIST_OBJ_PROPERTIES := ["_puppet_master", "_state_machine"]


const PuppetMasterScene: PackedScene = preload("res://game_objects/game_actors/actor_controllers/puppet_master.tscn")


signal moved(direction)

signal died


var velocity: Vector2 = Vector2()
var player_controlled: bool = false


var _first_time: bool = true
var _puppet_master: InputMaster
var _state_machine: ActorStateMachine


onready var _collision_shape: CollisionShape2D = $CollisionShape




func _ready() -> void:
	if _first_time:
		_first_time = false
		
		_puppet_master = PuppetMasterScene.instance()
		add_child(_puppet_master)
		
		_state_machine = ActorStateMachine.new()
		_state_machine.name = "StateMachine"
		_state_machine.game_object = self
		_state_machine.puppet_master = _puppet_master
		_state_machine.animation_tree_node = "../%s" % "AnimationTree"
		add_child(_state_machine)
	
	$StateLabel._state_machine = _state_machine
	$JobLabel._puppet_master = _puppet_master
	$EmployerLabel._puppet_master = _puppet_master


func _process(_delta: float) -> void:
	if _puppet_master and _state_machine:
		_puppet_master.process_commands(_state_machine, player_controlled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity)
	
	if not velocity == Vector2():
		emit_signal("moved", velocity)




func transfer_item(item: GameResource) -> void:
	_puppet_master.transfer_item(item)



func damage(damage_points: float, sender) -> bool:
	return _state_machine.damage(damage_points, sender)


func die() -> void:
	emit_signal("died")


func is_active() -> bool:
	return _state_machine.is_active()


func enable_collision(new_status: bool) -> void:
	_collision_shape.set_deferred("disabled", not new_status)
