class_name PlacementDummy
extends Area2D


const PLACEMENT_COLOR: Color = Color.white# Color("#1E90FF")
const OBSTRUCTED_COLOR: Color = Color.red #Color("#800000")

const GRID_SIZE: float = 16.0
const SLIGHT_OFFSET: Vector2 = Vector2(0, -0.01)




func _init(new_collision_shape: CollisionShape2D, _shape_offset: Vector2, new_sprite: Sprite, _sprite_offset: Vector2) -> void:
	add_child(new_collision_shape)
	add_child(new_sprite)
	
	#new_collision_shape.position += shape_offset
	#new_sprite.position += sprite_offset
	
	modulate = PLACEMENT_COLOR
	modulate.a = 0.75
	
	set_collision_layer_bit(0, false)
	
	for i in range(10):
		set_collision_mask_bit(i, true)


func _process(_delta: float) -> void:
	modulate = PLACEMENT_COLOR if place_free() else OBSTRUCTED_COLOR
	modulate.a = 0.75
	
	var mouse_position: Vector2 = get_global_mouse_position()
	
	global_position = Vector2(stepify(mouse_position.x, GRID_SIZE), stepify(mouse_position.y, GRID_SIZE)) + SLIGHT_OFFSET




func place_free() -> bool:
	return get_overlapping_bodies().empty()

func get_building_position() -> Vector2:
	return global_position - SLIGHT_OFFSET
