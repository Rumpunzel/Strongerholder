extends HBoxContainer


const RESOURCE_ICONS: Dictionary = {
	Constants.Resources.LUMBER: "res://ui/game_gui/resource_icons/icon_wood.png",
	Constants.Resources.WOOD_PLANKS: "res://ui/game_gui/resource_icons/icon_wood_planks.png",
	Constants.Resources.STONE: "res://ui/game_gui/resource_icons/icon_stone.png",
}


export(Constants.Resources) var _resource_to_count


var _quarter_master: QuarterMaster = null setget set_quarter_master




func _ready() -> void:
	$Icon.texture = load(RESOURCE_ICONS[_resource_to_count])
	
	ServiceLocator.connect("quarter_master_changed", self, "set_quarter_master")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _quarter_master:
		return
	
	var counted_amount: int = 0
	var storage_units: Array = _quarter_master.storage_buildings.get(_resource_to_count, [ ])
	
	for unit in storage_units:
		counted_amount += unit._pilot_master.how_many_of_item(_resource_to_count).size()
	
	$Amount.text = "%d" % counted_amount




func set_quarter_master(new_quarter_master: QuarterMaster) -> void:
	_quarter_master = new_quarter_master