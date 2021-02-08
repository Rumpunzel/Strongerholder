class_name GameSprite
extends Sprite


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const SCENE := "res://game_objects/components/game_sprite.tscn"

const PERSIST_PROPERTIES := [
	"sprite_sheets",
	"_current_sheet",
	"_first_time",
]


var sprite_sheets: Array = [ ]


var _first_time: bool = true
var _current_sheet: String setget set_current_sheet




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "Sprite"
	
	if _first_time:
		_first_time = false
		
		set_current_sheet(sprite_sheets[ randi() % sprite_sheets.size() ])
	
	assert(texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func set_current_sheet(new_sh: String) -> void:
	_current_sheet = new_sh
	texture = load(_current_sheet)



func get_copy_sprite() -> Sprite:
	return (duplicate() as Sprite)




#func set_sprite_path(new_paths: Array) -> void:
#	sprite_paths = new_paths
#
#	var directory := Directory.new()
#
#	if directory.dir_exists(sprite_path):
#		var images: Array = FileHelper.list_files_in_directory(sprite_path, false, ".png")
#
#		_sprite.texture = load(images[randi() % images.size()])
#	else:
#		_sprite.texture = load(sprite)
#
#	_sprite.offset.y = -_sprite.texture.get_height() / 2.0
