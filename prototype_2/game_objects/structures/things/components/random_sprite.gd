extends Sprite


export(Array, Texture) var _sprites



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = _sprites[randi() % _sprites.size()]
	offset.y = 16 - texture.get_height() / 2.0
	flip_h = randi() % 5 == 0
	modulate = Color(0.9 + randf() * 0.1, 0.9 + randf() * 0.1, 0.9 + randf() * 0.1)
