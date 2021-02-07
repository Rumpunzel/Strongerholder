extends MarginContainer


onready var _title: Label = $Info/Title
onready var _description: RichTextLabel = $Info/Description
onready var _image: TextureRect = $Info/Image
onready var _info: RichTextLabel = $Info/Info




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func object_selected(new_object: GameObject) -> void:
	if new_object:
		_title.text = new_object.name
		_image.texture = new_object._sprite.texture
