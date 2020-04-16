extends GameSprite


export(Array, Texture) var sprites



# Called when the node enters the scene tree for the first time.
func _ready():
	texture = sprites[randi() % sprites.size()]
	offset.y = texture.get_height() / 2.0
	flip_h = randi() % 5 == 0
	modulate = Color(0.9 + randf() * 0.1, 0.9 + randf() * 0.1, 0.9 + randf() * 0.1)
