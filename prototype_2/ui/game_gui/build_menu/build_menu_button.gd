class_name BuildMenuButton
extends Button


signal building_placed


var build_menu
var building_to_place: String




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", self, "place_building")
	
	var directory := Directory.new()
	var sprite: String = GameClasses.get_script_constant_map()[building_to_place].sprite
	
	if directory.dir_exists(sprite):
		var images: Array = FileHelper.list_files_in_directory(sprite, false, ".png")
		
		icon = load(images.front())
	else:
		icon = load(sprite)


func _init(building: String, menu) -> void:
	building_to_place = building
	build_menu = menu




func place_building() -> void:
	emit_signal("building_placed", GameClasses.spawn_class_with_name(building_to_place))
