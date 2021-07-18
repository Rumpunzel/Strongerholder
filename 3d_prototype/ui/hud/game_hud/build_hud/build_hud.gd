class_name BuildHUD
extends RadialMenu

export(PackedScene) var _build_item_scene: PackedScene = null
export(Array, Resource) var _buildable_structures := [ ]

export(Resource) var _game_pause_requested_channel
export(Resource) var _building_hud_toggled_channel


var _items := [ ]


onready var _placer: BuildingPlacer = $BuildingPlacer



func _enter_tree() -> void:
	# warning-ignore:return_value_discarded
	connect("item_selected", self, "_on_item_selected")
	# warning-ignore:return_value_discarded
	_game_pause_requested_channel.connect("raised", self, "close_menu")
	# warning-ignore:return_value_discarded
	_building_hud_toggled_channel.connect("raised", self, "_on_toggled")

func _exit_tree() -> void:
	_game_pause_requested_channel.disconnect("raised", self, "close_menu")
	_building_hud_toggled_channel.disconnect("raised", self, "_on_toggled")
	
	_free_items()



func _on_toggled() -> void:
	if _items.empty():
		_initialize_items()
	
	if _state == MenuState.CLOSED:
		_placer.current_structure = null
		open_menu(get_viewport_rect().size / 2.0)
	elif _state == MenuState.OPEN:
		close_menu()

func _initialize_items() -> void:
	for structure in _buildable_structures:
		var new_item: BuildHUDItem = _build_item_scene.instance()
		new_item.structure_resource = structure
		_items.append(new_item)
	
	_set_items(_items)

func _on_item_selected(inventory_item: BuildHUDItem, _submenu_item: BuildHUDItem) -> void:
	_placer.current_structure = inventory_item.structure_resource
	close_menu()


func _free_items() -> void:
	for item in _items:
		item.queue_free()
	_items.clear()
