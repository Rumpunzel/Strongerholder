extends Sprite3D


export(Array, Texture) var sprites



# Called when the node enters the scene tree for the first time.
func _ready():
	texture = sprites[randi() % sprites.size()]
	offset.y = texture.get_height() / 2.0