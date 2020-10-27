extends Button


export(PackedScene) var _building_to_place




# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", owner, "place_building", [_building_to_place.instance()])
