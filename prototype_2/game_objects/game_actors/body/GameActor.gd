class_name GameActor, "res://assets/icons/game_actors/icon_game_actor.svg"
extends KinematicBody2D


signal moved(direction)

signal activate
signal deactivate
signal died


var velocity: Vector2 = Vector2()


onready var _state_machine: StateMachine = $state_machine
onready var _puppet_master = $utility_nodes/puppet_master




func _setup(player_controlled: bool = false):
	_puppet_master.character_controller = InputMaster.new(_state_machine)
	activate_object()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	
	if not velocity == Vector2():
		emit_signal("moved", velocity)




func activate_object():
	emit_signal("activate")

func deactivate_object():
	emit_signal("deactivate")


func object_died():
	emit_signal("died")
