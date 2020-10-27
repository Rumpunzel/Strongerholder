class_name PlacementDummy
extends Area2D


const PLACEMENT_COLOR: Color = Color("1E90FF")
const OBSTRUCTED_COLOR: Color = Color("#800000")

const GRID_SIZE: float = 16.0




func _init(new_collision_shape: CollisionShape2D, new_sprite: Sprite):
	add_child(new_collision_shape)
	add_child(new_sprite)
	
	modulate = PLACEMENT_COLOR
	modulate.a = 0.5
	
	set_collision_layer_bit(0, false)
	
	for i in range(10):
		set_collision_mask_bit(i, true)


func _process(_delta: float):
	modulate = PLACEMENT_COLOR if get_overlapping_bodies().empty() else OBSTRUCTED_COLOR
	modulate.a = 0.5
	
	var mouse_position: Vector2 = get_global_mouse_position()
	
	global_position = Vector2(stepify(mouse_position.x, GRID_SIZE), stepify(mouse_position.y, GRID_SIZE))
