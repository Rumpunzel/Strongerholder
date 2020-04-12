extends AnimationTree


var blend_positions: Vector2 setget set_blend_positions, get_blend_positions




func _init():
	set_blend_positions(Vector2(0, 1))
	active = true




func set_blend_positions(new_direction: Vector2):
	blend_positions = new_direction
	
	set("parameters/idle/blend_position", blend_positions)
	set("parameters/run/blend_position", blend_positions)
	set("parameters/attack/blend_position", blend_positions)
	set("parameters/give/blend_position", blend_positions)
	set("parameters/idle_give/blend_position", blend_positions)



func get_blend_positions() -> Vector2:
	return blend_positions
