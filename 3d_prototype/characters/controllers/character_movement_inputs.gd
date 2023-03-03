class_name CharacterMovementInputs, "res://editor_tools/class_icons/nodes/icon_contract.svg"
extends Node

# warning-ignore-all:unused_class_variable

# Vector3 position to move to
onready var destination_input: Vector3 = owner.translation
# Vector3 direciton to move along
var movement_input: Vector3 = Vector3.ZERO

var is_running: bool = false
var jump_input: bool = false
var attack_input: bool = false
