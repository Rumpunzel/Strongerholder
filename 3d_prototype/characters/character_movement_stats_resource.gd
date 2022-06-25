class_name CharacterMovementStatsResource, "res://editor_tools/class_icons/resources/Icon_walk.svg"
extends Resource

# warning-ignore-all:unused_class_variable
export var move_speed: float = 8.0
export var move_acceleration: float = 12.0

export(float, 0.0, 1.0, 0.1) var walking_modifier: float = 0.7

export var jump_height: float = 2.0
export var aerial_modifier: float = 1.1
export var aerial_acceleration: float = 200.0

export var gravity_descend_multilpier: float = 4.0
export var gravity_ascend_multiplier: float = 2.0

export var air_resistance: float = 5.0
export var turn_rate: float = 10.0

export var avoid_obstacles: bool = true

export var _max_fall_speed: float = 50.0
export var _max_rise_speed: float = 100.0


func validate_vertical_speed(vertical_velocity: float) -> float:
	return clamp(vertical_velocity, -_max_fall_speed, _max_rise_speed)
