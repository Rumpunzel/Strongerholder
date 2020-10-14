class_name Puppeteer, "res://assets/icons/game_actors/icon_puppet_master.svg"
extends Node2D


export(NodePath) var _state_machine_node


onready var _state_machine: StateMachine = get_node(_state_machine_node)

onready var character_controller: InputMaster = PuppetMaster.new(_state_machine)




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	character_controller.process_commands()
