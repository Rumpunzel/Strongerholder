class_name CharacterMovementActions, "res://editor_tools/class_icons/nodes/icon_expand.svg"
extends Node

# warning-ignore-all:unused_class_variable
var horizontal_movement_vector: Vector2 setget _set_horizontal_movement_vector
var vertical_velocity: float

var moving_to_destination: bool = false
var target_speed: float = 1.0


func _process(_delta: float) -> void:
	_debug_path()


func _set_horizontal_movement_vector(new_vector: Vector2) -> void:
	horizontal_movement_vector = new_vector
	if horizontal_movement_vector != Vector2.ZERO:
		moving_to_destination = false

func _debug_path() -> void:
	# warning-ignore:unsafe_method_access
	var _navigation_agent: NavigationAgent = owner.get_navigation_agent()
	# warning-ignore:unsafe_method_access
	$Line.draw_path(_navigation_agent.get_nav_path())
	# warning-ignore:unsafe_property_access
	$Line.visible = moving_to_destination
	# warning-ignore:unsafe_property_access
	$MovementDingle.translation = _navigation_agent.get_target_location()
	# warning-ignore:unsafe_property_access
	$MovementDingle.visible = moving_to_destination
