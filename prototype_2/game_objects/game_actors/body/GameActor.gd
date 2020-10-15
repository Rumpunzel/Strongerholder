class_name GameActor, "res://assets/icons/game_actors/icon_game_actor.svg"
extends KinematicBody2D


signal moved(direction)

signal died


var velocity: Vector2 = Vector2()


onready var _collision_shape: CollisionShape2D = $collision_shape
onready var _state_machine: StateMachine = $state_machine
onready var _puppet_master: InputMaster = $puppet_master




func _setup(player_controlled: bool = false):
	_puppet_master.set_script(InputMaster if player_controlled else PuppetMaster)


func _process(_delta: float):
	_puppet_master.process_commands(_state_machine)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float):
	velocity = move_and_slide(velocity)
	
	if not velocity == Vector2():
		emit_signal("moved", velocity)




func damage(damage_points: float, sender) -> bool:
	return _state_machine.damage(damage_points, sender)


func die():
	visible = false
	_collision_shape.call_deferred("set_disabled", true)
	set_process(false)
	
	emit_signal("died")


func object_died():
	emit_signal("died")
